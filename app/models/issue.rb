# frozen_string_literal: true

class Issue < ApplicationRecord
   belongs_to :branch_path

   has_one :branch, through: :branch_path

   has_many :issue_assignees, dependent: :delete_all
   has_many :assignees, class_name: :Maintainer, through: :issue_assignees, source: :maintainer

   scope :active, -> { where(resolution: nil) }

   accepts_nested_attributes_for :issue_assignees, reject_if: :all_blank, allow_destroy: true

   delegate :arch, to: :branch_path

   validates_presence_of :no, :reporter, :status, :severity, :branch_path
end
