# frozen_string_literal: true

require 'rails_helper'

describe :RepocopNotesController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      # get '/ru/:branch/srpms/:reponame/repocop_notes' => 'repocop_notes#index'
      it do
         is_expected.to route(:get, '/ru/sisyphus/srpms/name/repocop_notes')
                    .to("repocop_notes#index", locale: :ru, branch: 'sisyphus', reponame: 'name')
      end
   end

   describe 'packages.a.o routing' do
      # get '/ru/srpm/:branch/:reponame/repocop', to: redirect('/%{locale}/sisyphus/srpms/:reponame')
      it do
         get '/ru/Sisyphus/srpms/name/repocop'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/repocop_notes")
      end
   end

   describe 'sisyphus.ru routing' do
      # get '/ru/srpm/:branch/:reponame/repocop', to: redirect('/%{locale}/sisyphus/srpms/:reponame/issues#repocop')
      it do
         get '/ru/srpm/Sisyphus/name/repocop'
         expect(response).to redirect_to("/ru/Sisyphus/srpms/name/repocop_notes")
      end
   end
end
