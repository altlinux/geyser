# frozen_string_literal: true

require 'rails_helper'

describe SrpmsController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # get '/ru' => 'srpms#index'
      it do
         is_expected.to route(:get, '/ru')
                    .to("srpms#index", locale: :ru)
      end

      # get '/ru/:branch/home' => 'srpms#index'
      it do
         is_expected.to route(:get, '/ru/sisyphus/home')
                    .to("srpms#index", locale: :ru, branch: 'sisyphus')
      end

      # get '/ru/:branch/srpms/:name' => 'srpms#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name')
                    .to("srpms#show", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:name/rpms' => 'srpms#rpms'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/rpms')
                    .to("srpms#rpms", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:name/:evrb' => 'srpms#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb')
                    .to("srpms#show", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end

      # get '/ru/:branch/srpms/:name/:evrb/rpms' => 'srpms#rpms'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb/rpms')
                    .to("srpms#rpms", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/:branch/srpms/name/get', to: redirect('/%{locale}/:branch/srpms/:name/rpms')
      it do
         get '/ru/Sisyphus/srpms/name/get'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/rpms")
      end

      # get '/ru/srpm/:branch/:name/gear', to: redirect('/%{locale}/sisyphus/srpms/:name')
      it do
         get '/ru/Sisyphus/srpms/name/gear'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name")
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:name/gear', to: redirect('/%{locale}/sisyphus/srpms/:name')
      it do
         get '/ru/srpm/Sisyphus/name'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name")
      end

      # get '/ru/srpm/:branch/:name', to: redirect('/%{locale}/sisyphus/srpms/:name')
      it do
         get '/ru/srpm/Sisyphus/name'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name")
      end

      # get '/ru/srpm/:branch/:name/get', to: redirect('/%{locale}/sisyphus/srpms/:name/rpms')
      it do
         get '/ru/srpm/Sisyphus/name/get'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/rpms")
      end
   end
end
