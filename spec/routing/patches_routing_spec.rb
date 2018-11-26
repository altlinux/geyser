# frozen_string_literal: true

require 'rails_helper'

describe PatchesController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/patches')
                    .to("patches#index", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/patches/patch')
                    .to("patches#show", locale: :ru, branch: 'sisyphus', reponame: 'name', patch_name: 'patch')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/patches/patch/download')
                    .to("patches#download", locale: :ru, branch: 'sisyphus', reponame: 'name', patch_name: 'patch')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/1:1.0-alt1-1542975608/patches')
                    .to("patches#index", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: '1:1.0-alt1-1542975608')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/1:1.0-alt1-1542975608/patches/patch')
                    .to("patches#show", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: '1:1.0-alt1-1542975608', patch_name: 'patch')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/1.0-alt1/patches/patch/download')
                    .to("patches#download", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: '1.0-alt1', patch_name: 'patch')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/srpm/:branch/:name/spec', to: redirect('/%{locale}/sisyphus/specfiles/:name')
      it do
         get '/ru/Sisyphus/srpms/name/spec'
         expect(response).to redirect_to("/ru/Sisyphus/specfiles/name")
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:name/spec', to: redirect('/%{locale}/sisyphus/specfiles/:name')
      it do
         get '/ru/srpm/sisyphus/reponame/patches'
         expect(response).to redirect_to("/ru/sisyphus/srpms/reponame/patches")
      end

      # get '/ru/srpm/:branch/:name/patches/0', to: redirect('/%{locale}/sisyphus/srpms/:name/patches/0')
      it do
         get '/ru/srpm/sisyphus/reponame/patches/0'
         expect(response).to redirect_to("/ru/sisyphus/srpms/reponame/patches/0")
      end
   end
end
