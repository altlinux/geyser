# frozen_string_literal: true

require 'rails_helper'

describe RpmsController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # get '/ru/:branch/srpms/:name/rpms' => 'srpms#rpms'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/rpms')
                    .to("rpms#index", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:name/:evrb/rpms' => 'srpms#rpms'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb/rpms')
                    .to("rpms#index", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/:branch/srpms/name/get', to: redirect('/%{locale}/:branch/srpms/:name/rpms')
      it do
         get '/ru/Sisyphus/srpms/name/get'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/rpms")
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:name/get', to: redirect('/%{locale}/sisyphus/srpms/:name/rpms')
      it do
         get '/ru/srpm/Sisyphus/name/get'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/rpms")
      end
   end
end
