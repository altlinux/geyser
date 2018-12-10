# frozen_string_literal: true

class Maintainer::Team < Maintainer
   has_many :team_people, primary_key: :login, foreign_key: :team_slug
   has_many :people, -> { distinct }, through: :team_people, class_name: 'Maintainer::Person'

   has_one :team_leader, primary_key: :login, foreign_key: :team_slug, class_name: 'TeamPerson'
   has_one :leader, through: :team_leader, class_name: 'Maintainer::Person', source: :person

   def to_param
      login[1..-1]
   end

   def login= value
      if value
         super(/^@/ =~ value && value || '@' + value)
      else
         super
      end
   end
end
