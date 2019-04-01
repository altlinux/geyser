require 'rails_helper'

RSpec.describe Repo, type: :model do
   it { is_expected.to be_a(ApplicationRecord) }

   context "Database" do
      it { is_expected.to have_db_column(:name).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:uri).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:path).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:kind).of_type(:string).with_options(null: false, default: 'origin') }
      it { is_expected.to have_db_column(:changed_at).of_type(:datetime).with_options(null: false, default: "1970-01-01 00:00:00 UTC") }

      it { is_expected.to have_db_index(:changed_at) }
      it { is_expected.to have_db_index(:kind) }
      it { is_expected.to have_db_index(:name) }
      it { is_expected.to have_db_index(:uri).unique(true) }
      it { is_expected.to have_db_index(:path) }
   end

   context "Associations" do
      it { is_expected.to belong_to(:holder).with_primary_key(:login).with_foreign_key(:holder_slug).class_name('Maintainer').optional }

      it { is_expected.to have_many(:repo_tags) }
      it { is_expected.to have_many(:tags).through(:repo_tags) }
      it { is_expected.to have_many(:authors).class_name('Maintainer') }
      it { is_expected.to have_many(:taggers).class_name('Maintainer') }
      it { is_expected.to have_many(:exercises).with_primary_key(:uri).with_foreign_key(:resource) }
      it { is_expected.to have_many(:tasks).through(:exercises) }
      it { is_expected.to have_many(:packages).through(:exercises).class_name('Package::Src') }
   end

   context "Validations" do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:uri) }
      it { is_expected.to validate_presence_of(:path) }
      it { is_expected.to validate_presence_of(:kind) }
      it { is_expected.to validate_presence_of(:changed_at) }
   end
end
