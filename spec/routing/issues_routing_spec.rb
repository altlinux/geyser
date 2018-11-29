# frozen_string_literal: true

require 'rails_helper'

describe :IssuesController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # get '/ru/:branch/srpms/:reponame/bugs' => 'issues#index'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/issues')
                    .to("issues#index", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:reponame/:evrb/bugs' => 'issues#index'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb/issues')
                    .to("issues#index", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/:branch/srpms/:reponame/get', to: redirect('/%{locale}/:branch/srpms/:reponame/rpms')
      it do
         get '/ru/Sisyphus/srpms/name/bugs'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/issues#bug")
      end

      # get '/ru/:branch/srpms/:reponame/get', to: redirect('/%{locale}/:branch/srpms/:reponame/rpms')
      it do
         get '/ru/Sisyphus/srpms/name/allbugs'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/issues#bug?q=all")
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:reponame/bugs', to: redirect('/%{locale}/sisyphus/srpms/:reponame/issues#bug')
      it do
         get '/ru/srpm/Sisyphus/name/bugs'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/issues#bug")
      end
   end
end
