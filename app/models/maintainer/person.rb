# frozen_string_literal: true

class Maintainer::Person < Maintainer
   has_many :team_people, primary_key: :login, foreign_key: :person_slug
   has_many :teams, -> { distinct }, through: :team_people, class_name: 'Maintainer::Team'

   def to_param
      login
   end
end
