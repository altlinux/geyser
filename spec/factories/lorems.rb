FactoryBot.define do
   factory :lorem do
      text { Faker::Lorem.sentence }
      codepage { Faker::Lorem.word }
      lang { 'ru' }
      package
   end
end
