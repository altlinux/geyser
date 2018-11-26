# frozen_string_literal: true

require 'rails_helper'

describe :ChangelogsController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # get '/ru/:branch/srpms/:name/changelogs' => 'changelogs#index'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/changelogs')
                    .to("changelogs#index", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end

      # get '/ru/:branch/srpms/:name/:evrb/changelogs' => 'changelogs#index'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/evrb/changelogs')
                    .to("changelogs#index", locale: :ru, branch: 'sisyphus', reponame: 'name', evrb: 'evrb')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/srpm/:branch/:name/changelog', to: redirect('/%{locale}/sisyphus/srpms/:name/changelogs')
      it do
         get '/ru/Sisyphus/srpms/name/changelog'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/changelogs")
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:name/changelog', to: redirect('/%{locale}/sisyphus/srpms/:name/changelogs')
      it do
         get '/ru/srpm/Sisyphus/name/changelog'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/changelogs")
      end
   end
end
