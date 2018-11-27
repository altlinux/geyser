# frozen_string_literal: true

FactoryBot.define do
   factory :maintainer do
      name { Faker::Name.name }
      sequence :login do |n|
         "#{ Faker::Internet.user_name }#{ n }"
      end
      time_zone 'UTC'
      jabber { "#{ login }@altlinux.org" }
      info { Faker::Lorem.paragraph }
      website { Faker::Internet.url }
      location { Faker::Address.country }

      after(:create) do |m, e|
         create(:email, maintainer: m)
      end
   end

   factory :person, parent: :maintainer, class: 'Maintainer::Person'
   factory :team, parent: :maintainer, class: 'Maintainer::Team'
end
