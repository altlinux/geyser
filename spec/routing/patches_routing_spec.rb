# frozen_string_literal: true

require 'rails_helper'

describe PatchesController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/reponame/patches')
                    .to("patches#index", locale: :ru, branch: 'sisyphus', name: 'reponame')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/reponame/patches/patch')
                    .to("patches#show", locale: :ru, branch: 'sisyphus', name: 'reponame', patch_name: 'patch')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/reponame/patches/patch/download')
                    .to("patches#download", locale: :ru, branch: 'sisyphus', name: 'reponame', patch_name: 'patch')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/reponame/1:1.0-alt1-1542975608/patches')
                    .to("patches#index", locale: :ru, branch: 'sisyphus', name: 'reponame', evrb: '1:1.0-alt1-1542975608')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/reponame/1:1.0-alt1-1542975608/patches/patch')
                    .to("patches#show", locale: :ru, branch: 'sisyphus', name: 'reponame', evrb: '1:1.0-alt1-1542975608', patch_name: 'patch')
      end

      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/reponame/1.0-alt1/patches/patch/download')
                    .to("patches#download", locale: :ru, branch: 'sisyphus', name: 'reponame', evrb: '1.0-alt1', patch_name: 'patch')
      end
   end

   describe 'packages.a.o routing' do
   end

   describe 'sisyphus.ru routing' do
      it do
         get '/ru/srpm/sisyphus/reponame/patches'
         expect(response).to redirect_to("/ru/sisyphus/srpms/reponame/patches")
      end
   end
end
