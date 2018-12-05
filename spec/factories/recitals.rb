FactoryBot.define do
   factory :recital do
      maintainer
   end

   factory :email, parent: :recital, class: 'Recital::Email' do
      address { "#{ maintainer.login }@altlinux.org" }
   end
end
