# frozen_string_literal: true

class Issue::Bug < Issue
   OPEN_STATUSES = %w(NEW ASSIGNED VERIFIED REOPENED)

   validates :no, numericality: { only_integer: true }

   scope :opened, -> { where(status: OPEN_STATUSES) }
   scope :for_maintainer_and_branch, ->(maintainer, branch) do
      names = branch.spkgs.where(name: maintainer.acl_names).select(:name).distinct

      where(component: names)
         .or(where(assigned_to: maintainer.email))
         .order(no: :desc)
   end
end
