# frozen_string_literal: true

require 'rails_helper'

describe RepocopNotesController do
   let(:srpm) { create(:srpm) }

   describe '#index' do
      before { get :index, params: { reponame: srpm.name, locale: 'en', branch: srpm.branch.slug } }

      it { is_expected.to render_template(:index) }

      it { is_expected.to respond_with(:ok) }
   end
end
