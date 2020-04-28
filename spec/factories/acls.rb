FactoryBot.define do
  factory :acl do
    package_name { Faker::Internet.username }
    owner { true }

    association :branch_path
    association :maintainer
  end
end
