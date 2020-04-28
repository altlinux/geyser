FactoryBot.define do
  factory :task_rpm do
    md5 { Faker::Alphanumeric.alpha(number: 10) }
    association :task
  end
end
