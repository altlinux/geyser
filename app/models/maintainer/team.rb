# frozen_string_literal: true

class Maintainer::Team < Maintainer
   has_many :team_people, primary_key: :login, foreign_key: :team_slug
   has_many :people, -> { distinct }, through: :team_people, class_name: 'Maintainer::Person'

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
