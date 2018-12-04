# frozen_string_literal: true

require 'rails_helper'

describe MaintainersController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # resources :maintainers, only: :index
      it do
         is_expected.to route(:get, '/ru/sisyphus/maintainers')
                    .to("maintainers#index", locale: :ru, branch: 'sisyphus')
      end

      # get 'maintainers/:login/show' => 'maintainers#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/maintainers/login')
                    .to("maintainers#show", locale: :ru, branch: 'sisyphus', login: 'login')
      end

      # get 'maintainers/:login/srpms' => 'maintainers#srpms'
      it do
         is_expected.to route(:get, '/ru/sisyphus/maintainers/login/srpms')
                    .to("srpms#maintained", locale: :ru, branch: 'sisyphus', login: 'login')
      end

      # get 'maintainers/:login/gear' => 'maintainers#gear'
      it do
         is_expected.to route(:get, '/ru/sisyphus/maintainers/login/gears')
                    .to("gears#index", locale: :ru, branch: 'sisyphus', login: 'login')
      end

      # get 'maintainers/:login/issues' => 'maintainers#issues'
      it do
         is_expected.to route(:get, '/ru/sisyphus/maintainers/login/bugs')
                    .to("issues#bugs", locale: :ru, branch: 'sisyphus', login: 'login')
      end

      # get 'maintainers/:login/ftbfs' => 'maintainers#ftbfs'
      it do
         is_expected.to route(:get, '/ru/sisyphus/maintainers/login/ftbfses')
                    .to("issues#ftbfses", locale: :ru, branch: 'sisyphus', login: 'login')
      end

      # get 'maintainers/:login/watch' => 'maintainers#novelties'
      it do
         is_expected.to route(:get, '/ru/sisyphus/maintainers/login/watch')
                    .to("issues#novelties", locale: :ru, branch: 'sisyphus', login: 'login')
      end

      # get 'maintainers/:id/repocop_notes' => 'maintainers#repocop_notes'
      it do
         is_expected.to route(:get, '/ru/sisyphus/maintainers/login/repocop_notes')
                    .to("repocop_notes#maintained", locale: :ru, branch: 'sisyphus', login: 'login')
      end
   end

   describe 'packages.a.o routing' do
      it do
         get '/ru/Sisyphus/maintainers/login/gear'
         expect(response).to redirect_to("/ru/Sisyphus/maintainers/login/gears")
      end

      it do
         get '/ru/Sisyphus/maintainers/login/ftbfs'
         expect(response).to redirect_to("/ru/Sisyphus/maintainers/login/ftbfses")
      end

      it do
         get '/ru/Sisyphus/maintainers/login/allbugs'
         expect(response).to redirect_to("/ru/Sisyphus/maintainers/login/bugs?q=all")
      end

      it do
         get '/ru/Sisyphus/maintainers/login/repocop'
         expect(response).to redirect_to("/ru/Sisyphus/maintainers/login/repocop_notes")
      end
   end

   describe 'sisyphus.ru routing' do
      # get 'people', to: redirect('/%{locale}/sisyphus/maintainers')
      it do
         get '/ru/people'
         expect(response).to redirect_to("/ru/sisyphus/maintainers")
      end

      # get 'packager/:login', to: redirect('/%{locale}/sisyphus/maintainers/%{login}')
      it do
         get '/ru/packager/login'
         expect(response).to redirect_to("/ru/sisyphus/maintainers/login")
      end

      it do
         get '/ru/packager/login/srpms'
         expect(response).to redirect_to("/ru/sisyphus/maintainers/login/srpms")
      end

      it do
         get '/ru/packager/login/bugs'
         expect(response).to redirect_to("/ru/sisyphus/maintainers/login/issues#bug")
      end

      it do
         get '/ru/packager/login/repocop'
         expect(response).to redirect_to("/ru/sisyphus/maintainers/login/repocop_notes")
      end
   end
end
