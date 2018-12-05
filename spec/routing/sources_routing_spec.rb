# frozen_string_literal: true

require 'rails_helper'

describe SourcesController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # get '/ru/:branch/srpms/:reponame/sources' => 'srpms#sources'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/sources')
                    .to("sources#index", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:reponame/sources/:source_name' => 'sources#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/sources/srcname')
                    .to("sources#show", locale: :ru, branch: 'sisyphus', reponame: 'name', source_name: 'srcname')
      end

      # get '/ru/:branch/srpms/:reponame/sources/:source_name' => 'sources#download'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/sources/srcname/download')
                    .to("sources#download", locale: :ru, branch: 'sisyphus', reponame: 'name', source_name: 'srcname')
      end

      # get '/ru/:branch/srpms/:reponame/:evrb/sources' => 'srpms#sources'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb/sources')
                    .to("sources#index", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end

      # get '/ru/:branch/srpms/:reponame/:evrb/sources/:source_name' => 'sources#show'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb/sources/srcname')
                    .to("sources#show", locale: :ru, branch: 'sisyphus', reponame: 'name', source_name: 'srcname', evrb: 'evrb')
      end

      # get '/ru/:branch/srpms/:reponame/:evrb/sources/:source_name' => 'sources#download'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb/sources/srcname/download')
                    .to("sources#download", locale: :ru, branch: 'sisyphus', reponame: 'name', source_name: 'srcname', evrb: 'evrb')
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:reponame/sources', to: redirect('/%{locale}/sisyphus/srpms/:reponame/sources')
      it do
         get '/ru/srpm/Sisyphus/name/sources'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/sources")
      end

      # get '/ru/srpm/:branch/:reponame/sources/0', to: redirect('/%{locale}/sisyphus/srpms/:reponame/sources/0')
      it do
         get '/ru/srpm/Sisyphus/name/sources/0'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/sources/0")
      end

      # get '/ru/srpm/:branch/:reponame/getsource/0', to: redirect('/%{locale}/sisyphus/srpms/:reponame/sources/0')
      it do
         get '/ru/srpm/Sisyphus/name/getsource/0'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/sources/0/download")
      end
   end
end
