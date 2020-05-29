# frozen_string_literal: true

class Rpm < ApplicationRecord
   belongs_to :branch_path, inverse_of: :rpms
   belongs_to :package, autosave: true

   has_one :branch, through: :branch_path
   has_one :builder, through: :package, class_name: 'Maintainer'

   default_scope -> { where(obsoleted_at: nil) }

   scope :by_branch_path, ->(id) { where(branch_path_id: id) }
   scope :by_name, ->(name) { where(name: name) }
   scope :names, -> { select(:name).distinct }
   scope :src, -> { joins(:package).where(packages: { arch: 'src' })}
   scope :active, -> { joins(:branch_path).merge(BranchPath.active) }
   scope :published, -> { joins(:branch_path).merge(BranchPath.published) }
   scope :by_evr, ->(evr) { joins(:package).merge(Package.by_evr(evr)) }

   delegate :evr, :arch, to: :package

   validates_presence_of :branch_path, :filename

   before_save :fill_name_in, on: :create

   def filepath
      File.join(branch_path.path, self.filename)
   end

   def ftp_url
      File.join(branch_path.ftp_url, self.filename)
   end

   def is_obsoleted?
      obsoleted_at.present?
   end

   def exists?
      scope = self.class.unscoped.where(branch_path_id: branch_path_id,
                                        filename: filename,
                                        package_id: package_id,
                                        obsoleted_at: obsoleted_at)

      scope.present?
   end

   def file_exists?
      File.exists?(filepath)
   end

   protected

   def fill_name_in
      self.name ||= filename.split(/-/)[0...-2].join('-')
   end
end
