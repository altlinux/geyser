# frozen_string_literal: true

class IssueAssignee < ApplicationRecord
   belongs_to :issue
   belongs_to :maintainer
end
