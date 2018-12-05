# frozen_string_literal: true

require 'rails_helper'

describe :SpecfilesController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # get '/ru/:branch/srpms/:reponame/spec' => 'specfiles#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/specfiles/name')
                    .to("specfiles#show", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:reponame/rawspec' => 'specfiles#raw'
      it do
         is_expected.to route(:get, '/ru/sisyphus/specfiles/name/raw')
                    .to("specfiles#raw", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:reponame/:evrb/spec' => 'specfiles#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/specfiles/name/evrb')
                    .to("specfiles#show", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end

      # get '/ru/:branch/srpms/:reponame/:evrb/rawspec' => 'specfiles#raw'
      it do
         is_expected.to route(:get, '/ru/sisyphus/specfiles/name/evrb/raw')
                    .to("specfiles#raw", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/srpm/:branch/:reponame/spec', to: redirect('/%{locale}/sisyphus/specfiles/:reponame')
      it do
         get '/ru/Sisyphus/srpms/name/spec'
         expect(response).to redirect_to("/ru/Sisyphus/specfiles/name")
      end

      # get '/ru/srpm/:branch/:reponame/rawspec', to: redirect('/%{locale}/sisyphus/specfiles/:reponame/raw')
      it do
         get '/ru/Sisyphus/srpms/name/rawspec'
         expect(response).to redirect_to("/ru/Sisyphus/specfiles/name/raw")
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:reponame/spec', to: redirect('/%{locale}/sisyphus/srpms/:reponame/spec')
      it do
         get '/ru/srpm/Sisyphus/name/spec'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/spec")
      end
   end
end
