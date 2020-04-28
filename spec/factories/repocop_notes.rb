FactoryBot.define do
  factory :repocop_note do
    status { Faker::Number.number(digits: 10) }
    kind { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }

    association :package
  end
end
