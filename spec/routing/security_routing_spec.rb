# frozen_string_literal: true

require 'rails_helper'

describe SecurityController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # resources :security, only: :index
      it do
         is_expected.to route(:get, '/ru/sisyphus/security')
                    .to("security#index", locale: :ru, branch: 'sisyphus')
      end
   end

   describe 'sisyphus.ru routing' do
      # get ':locale/security', to: redirect('/%{locale}/sisyphus/security')
      it do
         get '/ru/security'
         expect(response).to redirect_to("/ru/sisyphus/security")
      end
   end
end
