require 'rails_helper'

RSpec.describe RepoTag, type: :model do
   context "Database" do
      it { is_expected.to have_db_column(:repo_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:tag_id).of_type(:integer).with_options(null: false) }

      it { is_expected.to have_db_index(:repo_id) }
      it { is_expected.to have_db_index(:tag_id) }
      it { is_expected.to have_db_index(%i(repo_id tag_id)).unique(true) }
   end

   context "Associations" do
      it { is_expected.to belong_to(:repo) }
      it { is_expected.to belong_to(:tag) }
   end
end
