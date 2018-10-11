# frozen_string_literal: true

class Package < ApplicationRecord
   class AlreadyExistError < StandardError; end
   class SourceIsntFound < StandardError; end
   class AttachedNewBranchError < StandardError; end
   class InvalidMd5SumError < StandardError; end

   belongs_to :group
   belongs_to :builder, class_name: 'Maintainer', inverse_of: :rpms, counter_cache: :srpms_count
   has_many :rpms, inverse_of: :package, dependent: :destroy
   has_many :branch_paths, through: :rpms
   has_many :branches, through: :branch_paths

   validates_presence_of :buildtime, :md5, :group, :builder, :name, :arch

   scope :ordered, -> { order('packages.buildtime DESC') }
   scope :by_name, ->(name) { where(name: name) }
   scope :src, -> { where(arch: 'src') }
   scope :built, -> { where.not(arch: 'src') }
   scope :by_branch_slug, ->(slug) { slug.blank? && all || joins(:branches).where(branches: { slug: slug }) }
   scope :by_arch, ->(arch) do
      if arch.blank?
         all
      else
         subquery = "SELECT DISTINCT src_id FROM packages WHERE packages.arch IN (?)"
         where("packages.id IN (#{subquery})", arch)
      end
   end
   scope :by_evr, ->(evr) do
      if evr.blank?
         all
      else
         evrs = evr.split(/[:\-]/)

         if evrs.size == 2
            where(version: evrs[0], release: evrs[1])
         else
            where(epoch: evrs[0], version: evrs[1], release: evrs[2])
         end
      end
   end
   scope :query, ->(text) do
      if text.blank?
         all
      else
         subquery = "
            SELECT DISTINCT src_id FROM (SELECT src_id, tsv, ts_rank_cd(tsv, plainto_tsquery('#{text}'))
            FROM packages, plainto_tsquery(?) AS q
            WHERE (tsv @@ q)
            ORDER BY ts_rank_cd(tsv, plainto_tsquery(?)) DESC) as t1"
         where("packages.id IN (#{subquery})", text, text)
      end
   end
   singleton_class.send(:alias_method, :q, :query)
   singleton_class.send(:alias_method, :a, :by_arch)
   singleton_class.send(:alias_method, :b, :by_branch_slug)

   validates_presence_of :buildtime, :md5, :groupname, :builder

   def to_param
      name
   end

   def evr
      [epoch, "#{version}-#{release}"].compact.join(":")
   end

   def first_presented_filepath
      rpms.map do |rpm|
         File.file?(filepath = rpm.filepath) && filepath || nil
      end.compact.first
   end

   def last_changelog_text
      changelogs&.last&.text
   end

   def first_branch
      branches.first
   end

   def self.source
      @source ||= self.to_s.split('::').last
   end

   def self.import branch_path, rpm
      if !rpm.has_valid_md5?
         raise InvalidMd5SumError
      end

      package = Package.find_or_initialize_by(md5: rpm.md5) do |package|
         if rpm.sourcerpm
            spkg_id = Rpm.where(filename: rpm.sourcerpm,
                                branch_path_id: branch_path.branch.branch_paths.src.select(:id)).first&.package_id

            if spkg_id
               package.src_id = spkg_id
            else
               raise SourceIsntFound.new(rpm.sourcerpm)
            end
         end

         package.name = rpm.name
         package.version = rpm.version
         package.release = rpm.release
         package.epoch = rpm.epoch
         package.arch = rpm.arch
         package.buildhost = rpm.buildhost

         package.summary = rpm.summary
         package.license = rpm.license
         package.url = rpm.url
         package.description = rpm.description
         package.vendor = rpm.vendor
         package.distribution = rpm.distribution
         package.buildtime = rpm.buildtime
         package.size = rpm.size

         package.builder = Maintainer.import_from_changelogname(rpm.change_log.first[1])

         BranchingMaintainer.find_or_create_by!(maintainer: package.builder,
                                                branch: branch_path.branch)

         m = Maintainer.import_from_changelogname(rpm.packager)

         BranchingMaintainer.find_or_create_by!(maintainer: m,
                                                branch: branch_path.branch)

         package.type = rpm.sourcerpm && 'Package::Built' || 'Package::Src'

         package.rpms << Rpm.new(branch_path: branch_path,
                                 filename: rpm.filename)
      end

      if !package.group
         group_name = rpm.group
         Group.import(branch_path.branch, group_name)
         group = Group.in_branch(branch_path.branch, group_name)
         package.group = group
         package.groupname = group_name
      end

      if package.new_record?
         package.save!
         if rpm.sourcerpm
            #Provide.import_provides(rpm, package)
            #Require.import_requires(rpm, package)
            #Conflict.import_conflicts(rpm, package)
            #Obsolete.import_obsoletes(rpm, package)
         else
            Changelog.import_from(rpm, package)
            Specfile.import(rpm, package)
            Patch.import(rpm, package)
            Source.import_from(rpm, package)
         end
      else
         if package.changed?
            package.save!
         end
         
         if package.branch_paths.include?(branch_path)
            raise AlreadyExistError
         else
            rpm = Rpm.new(branch_path_id: branch_path.id,
                          filename: rpm.filename,
                          package_id: package.id)

            rpm.save! if !rpm.exists?

            raise AttachedNewBranchError
         end
      end
   end

   def self.import_all branch
      time = Time.zone.now
      Rails.logger.info "IMPORT: at #{time} for #{branch.name} in"

      branch.branch_paths.send(source.downcase).active.each do |branch_path|
         next if !File.directory?(branch_path.path)

         Rails.logger.info "IMPORT: Branch path #{branch_path.path}"

         mins = (time - branch_path.imported_at + 59).to_i / 60
         find = "find #{branch_path.path} -name '#{branch_path.glob}' | sed 's|#{branch_path.path}/*||' | sort"
         Rails.logger.info "IMPORT: search with: #{find}"

         current_list = `#{find}`.split("\n")
         stored_list = branch_path.rpms.where(filename: current_list).select(:filename).pluck(:filename)

         nonexist_list = current_list - stored_list
         Rails.logger.info "IMPORT: will be imported #{nonexist_list.size} files"

         nonexist_list.each do |file|
            self.transaction do
               filepath = File.join(branch_path.path, file)
               Rails.logger.info "IMPORT: file #{filepath}"
               rpm = Rpm::Base.new(filepath)

               info = "IMPORT: file '#{ filepath }' "
               (method, state) = begin
                  Package.import(branch_path, rpm)
                  [ :info, "imported to branch #{branch_path.branch.name}" ]
               rescue AttachedNewBranchError
                  [ :info, "added to branch #{branch_path.branch.name}" ]
               rescue AlreadyExistError
                  [ :info, "exists in #{branch_path.branch.name}... skipping" ]
               rescue SourceIsntFound => e
                  [ :error, "#{e.message} source isn't found for #{branch_path.branch.name}" ]
               rescue InvalidMd5SumError => e
                  [ :error, "has invalid MD5 sum" ]
               rescue => e
                  time = time < rpm.buildtime && time || rpm.buildtime
                  [ :error, "failed to update, reason: #{e.message} at #{e.backtrace[0]}" ]
               end

               Rails.logger.send(method, info + state)
            end
         end

         branch_path.update(imported_at: time, srpms_count: branch_path.rpms.count)
      end
    
      if source.downcase == 'src'
         branch.update(srpms_count: branch.srpm_filenames.count)

         Group.find_each do |group|
            group.update!(srpms_count: group.srpms.count)
         end
      end
   end

   class ActiveRecord_Relation
      def page value
         @page = (value || 1).to_i
         @total_count = self[0] && self.size || 0

         self.class_eval do
            def total_count
               @total_count
            end

            def total_pages
               (@total_count + 24) / 25
            end

            def current_page
               @page
            end

            def each &block
               range = ((@page - 1) * 25...@page * 25)
               self[range].each(&block)
            end
         end

         self
      end
   end
end
