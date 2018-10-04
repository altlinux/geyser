# frozen_string_literal: true

class Bug < ApplicationRecord
   OPEN_STATUSES = ['NEW', 'ASSIGNED', 'VERIFIED', 'REOPENED']

   validates :bug_id, presence: true

   validates :bug_id, numericality: { only_integer: true }

   scope :opened, -> { where(bug_status: OPEN_STATUSES) }
   scope :for_maintainer_and_branch, ->(maintainer, branch) do
      names = branch.spkgs.where(name: maintainer.acl_names).select(:name).distinct

      where(component: names)
         .or(where(assigned_to: maintainer.email))
         .order(bug_id: :desc)
   end
end
