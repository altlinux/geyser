require 'rails_helper'

RSpec.describe Tag, type: :model do
   context "Database" do
      it { is_expected.to have_db_column(:sha).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:alt).of_type(:boolean) }
      it { is_expected.to have_db_column(:signed).of_type(:boolean) }
      it { is_expected.to have_db_column(:authored_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:tagged_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:author_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:tagger_id).of_type(:integer) }
      it { is_expected.to have_db_column(:message).of_type(:text) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }

      it { is_expected.to have_db_index(:author_id) }
      it { is_expected.to have_db_index(:authored_at) }
      it { is_expected.to have_db_index(:name) }
      it { is_expected.to have_db_index(:sha).unique(true) }
      it { is_expected.to have_db_index(:tagged_at) }
      it { is_expected.to have_db_index(:tagger_id) }
   end

   context "Associations" do
      it { is_expected.to belong_to(:author).class_name("Maintainer") }
      it { is_expected.to belong_to(:tagger).class_name("Maintainer") }

      it { is_expected.to have_many(:repo_tags) }
      it { is_expected.to have_many(:repos).through(:repo_tags) }
   end

   context "Validations" do
      it { is_expected.to validate_presence_of(:sha) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:authored_at) }
      it { is_expected.to validate_presence_of(:tagged_at) }
   end
end
