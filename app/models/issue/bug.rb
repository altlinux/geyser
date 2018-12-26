# frozen_string_literal: true

class Issue::Bug < Issue
   OPEN_STATUSES = %w(NEW ASSIGNED VERIFIED REOPENED)

   validates :no, numericality: { only_integer: true }

   scope :opened, -> { where(status: OPEN_STATUSES) }
   scope :for_maintainer_and_branch, ->(maintainer, branch) do
      branch_path_ids = branch.branch_paths.select(:id)

      joins(:issue_assignees, :branch_path)
         .where(branch_path_id: branch_path_ids,
                issue_assignees: { maintainer_id: maintainer.id })
         .order("issues.no::integer DESC")
         .select("distinct on (issues.no::integer) issues.*")
   end

   default_scope -> { order(Arel.sql("issues.no::integer DESC")) }
end
