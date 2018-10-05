# frozen_string_literal: true

class BranchingMaintainer < ApplicationRecord
   belongs_to :branch
   belongs_to :maintainer

   delegate :name, :slug, :login, to: :maintainer
   delegate :name, :slug, to: :branch, prefix: true

   scope :top, ->(limit, branch) { person.where(branch_id: branch.id).order('branching_maintainers.srpms_count DESC').limit(limit) }
   scope :useful, -> { where.not(srpms_count: 0) }
   scope :for_branch, ->(branch) { where(branch_id: branch) }
   scope :person, -> { joins(:maintainer).merge(Maintainer.person) }
   scope :team, -> { joins(:maintainer).merge(Maintainer.team) }

   def update_count!
      srpms_count = maintainer.acl_names.joins(:branch_path).where(branch_paths: { branch_id: branch }).count
      self.update!(srpms_count: srpms_count)
   end
end
