# frozen_string_literal: true

class RemoveOldSrpms < Rectify::Command
   attr_reader :branch_path

   def initialize branch_path
      @branch_path = branch_path
   end

   def log *args
      Rails.logger.info *args
   end

   def list
      find = "find #{branch_path.path} -name '#{branch_path.glob}' | sed 's|#{branch_path.path}/*||' | sort"

      current_list = `#{find}`.split("\n")
      stored_list = branch_path.rpms.select(:filename).pluck(:filename)

      stored_list - current_list
   end

   def count
      list.count
   end

   def call
      ApplicationRecord.transaction do
         list = self.list

         list_to_remove = branch_path.rpms.where(filename: list)
         builder_ids = Package.where(id: list_to_remove.select(:package_id)).select(:builder_id).distinct.pluck(:builder_id)

         list_to_remove.update_all(obsoleted_at: Time.zone.now)
         list.each { |f| Rails.logger.info "IMPORT: removed file #{f} for #{branch_path.name}" }

         branch_path.update!(srpms_count: branch_path.srpm_filenames.count)
         branch_path.branch.update!(srpms_count: branch_path.branch.public_srpm_filenames.count)

         branch_path.builders.where(id: builder_ids).find_each do |maintainer|
            maintainer.branching_maintainers.where(branch_id: branch_path.branch).each do |branching_maintainer|
               branching_maintainer.update_count!
            end
         end
      end

      broadcast(:ok)
   end
end
