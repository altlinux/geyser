# frozen_string_literal: true

require 'rails_helper'

describe :IssuesController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # get '/ru/:branch/srpms/:name/bugs' => 'issues#index'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/issues')
                    .to("issues#index", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:name/:evrb/bugs' => 'issues#index'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb/issues')
                    .to("issues#index", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/:branch/srpms/name/get', to: redirect('/%{locale}/:branch/srpms/:name/rpms')
      it do
         get '/ru/Sisyphus/srpms/name/bugs'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/issues#bug")
      end

      # get '/ru/:branch/srpms/name/get', to: redirect('/%{locale}/:branch/srpms/:name/rpms')
      it do
         get '/ru/Sisyphus/srpms/name/allbugs'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/issues#bug?q=all")
      end

      # get '/ru/srpm/:branch/:name/gear', to: redirect('/%{locale}/sisyphus/srpms/:name')
      it do
         get '/ru/Sisyphus/srpms/name/repocop'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/issues#repocop")
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:name/bugs', to: redirect('/%{locale}/sisyphus/srpms/:name/issues#bug')
      it do
         get '/ru/srpm/Sisyphus/name/bugs'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/issues#bug")
      end

      # get '/ru/srpm/:branch/:name/repocop', to: redirect('/%{locale}/sisyphus/srpms/:name/issues#repocop')
      it do
         get '/ru/srpm/Sisyphus/name/repocop'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/issues#repocop")
      end
   end
end
