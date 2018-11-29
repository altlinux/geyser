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

      # get '/ru/:branch/srpms/:name/:evrb' => 'srpms#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb')
                    .to("srpms#show", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/srpm/:branch/:name/gear', to: redirect('/%{locale}/sisyphus/srpms/:name')
      it do
         get '/ru/Sisyphus/srpms/name/gear'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name")
      end

      # get '/:name', to: redirect('/ru/sisyphus/srpms/:name')
      it do
         get '/name'
         expect(response).to redirect_to("/ru/sisyphus/srpms/name")
      end

      # get '/src::name', to: redirect('/ru/sisyphus/srpms/:name')
      it do
         get '/src:name'
         expect(response).to redirect_to("/ru/sisyphus/srpms/name")
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
   end
end
