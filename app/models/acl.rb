# frozen_string_literal: true

class Acl < ApplicationRecord
   belongs_to :branch_path
   belongs_to :maintainer, primary_key: :maintainer_slug, foreign_key: :login, optional: true

   has_one :branch, through: :branch_path

   scope :in_branch, ->(branch) { joins(:branch).where(branches: {id: branch}) }
   scope :people, -> { where("maintainer_slug !~ '^@.*'", ) }
   scope :teams, -> { where("maintainer_slug ~ '^@.*'", ) }
   scope :owner, -> { where(owner: true) }

   scope :maintainer_slugs, -> { select(:maintainer_slug).distinct }
end
