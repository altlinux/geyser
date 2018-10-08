# frozen_string_literal: true

class Rpm < ApplicationRecord
   belongs_to :branch_path, inverse_of: :rpms, counter_cache: :srpms_count
   belongs_to :package, autosave: true

   has_one :branch, through: :branch_path
   has_one :builder, through: :package, class_name: 'Maintainer'

   default_scope -> { where(obsoleted_at: nil) }

   scope :by_branch_path, ->(id) { where(branch_path_id: id) }
   scope :by_name, ->(name) { where(name: name) }
   scope :names, -> { select(:name).distinct }
   scope :src, -> { joins(:package).where(packages: { arch: 'src' })}

   delegate :arch, to: :package

   before_create   :increment_branch_path_counter
   before_destroy  :decrement_branch_path_counter

#   after_create    :update_branching_maintainer_counter
#   after_update    :update_branching_maintainer_counter, if: :is_obsoleted?

   validates_presence_of :branch_path, :filename

   before_save :fill_name_in, on: :create

   def filepath
      File.join(branch_path.path, self.filename)
   end

   def is_obsoleted?
      obsoleted_at.present?
   end

   def fill_name_in
      self.name ||= filename.split(/-/)[0...-2].join('-')
   end

   def exists?
      scope = self.class.unscoped.where(branch_path_id: branch_path_id,
                                        filename: filename,
                                        package_id: package_id,
                                        obsoleted_at: obsoleted_at)

      scope.present?
   end

   protected

#   def update_branching_maintainer_counter
#      BranchingMaintainer.find_or_initialize_by(maintainer_id: builder, branch_id: branch).update_count!
#   end

   def decrement_branch_path_counter
      BranchPath.decrement_counter(:srpms_count, branch_path.id)
   end

   def increment_branch_path_counter
      BranchPath.increment_counter(:srpms_count, branch_path.id)
   end
end
