# frozen_string_literal: true

FactoryBot.define do
   factory :group do
      name { Faker::App.name }
      name_en { Faker::App.name }
      path { Faker::Name.unique.name.gsub(/[^A-Za-z0-9]+/, '_') }
   end
end
