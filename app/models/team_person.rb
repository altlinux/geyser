# frozen_string_literal: true

class TeamPerson < ApplicationRecord
   belongs_to :person, class_name: 'Maintainer::Person', foreign_key: 'person_slug', primary_key: 'login', optional: true
   belongs_to :team, class_name: 'Maintainer::Team', foreign_key: 'team_slug', primary_key: 'login', optional: true
   belongs_to :branch_path

   has_one :branch, through: :branch_path
end
