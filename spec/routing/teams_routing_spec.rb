# frozen_string_literal: true

require 'rails_helper'

describe TeamsController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # resources :teams, only: :index
      it do
         is_expected.to route(:get, '/ru/sisyphus/teams')
                    .to("teams#index", locale: :ru, branch: 'sisyphus')
      end

      # get 'teams/:login/show' => 'teams#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/teams/login')
                    .to("teams#show", locale: :ru, branch: 'sisyphus', login: 'login')
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/team/login', to: redirect('/%{locale}/sisyphus/teams/login')
      it do
         get '/ru/team/login'
         expect(response).to redirect_to("/ru/sisyphus/teams/login")
      end
   end
end
