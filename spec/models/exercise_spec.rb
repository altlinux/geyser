require 'rails_helper'

RSpec.describe Exercise, type: :model do
  context "Database" do
      it { is_expected.to have_db_column(:no).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:kind).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:pkgname).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:resource).of_type(:string) }
      it { is_expected.to have_db_column(:sha).of_type(:string) }
      it { is_expected.to have_db_column(:task_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:committer_slug).of_type(:string).with_options(null: false) }

      it { is_expected.to have_db_index(:task_id) }
      it { is_expected.to have_db_index(:committer_slug) }
      it { is_expected.to have_db_index(%i(task_id no)).unique(true) }
      it { is_expected.to have_db_index(:no) }
      it { is_expected.to have_db_index(:pkgname) }
      it { is_expected.to have_db_index(:resource) }
      it { is_expected.to have_db_index(:sha) }
   end

   context "Associations" do
      it { is_expected.to belong_to(:task) }
      it { is_expected.to belong_to(:committer) }

      it { is_expected.to have_one(:tag) }

      it { is_expected.to have_many(:repos).with_primary_key(:resource).with_foreign_key(:uri) }
      it { is_expected.to have_many(:packages).with_primary_key(:pkgname).with_foreign_key(:name) }
      it { is_expected.to have_many(:exercise_approvers) }
      it { is_expected.to have_many(:approvers).through(:exercise_approvers) }
   end

   context "Delegates" do
      it { is_expected.to delegate_method(:name).to(:tag).with_prefix(:tag) }
   end

   context "Validations" do
      it { is_expected.to validate_presence_of(:no) }
      it { is_expected.to validate_presence_of(:kind) }
      it { is_expected.to validate_presence_of(:pkgname) }

      context "When kind is repo" do
         subject { described_class.new(kind: "repo") }

         it { is_expected.to validate_presence_of(:resource) }
         it { is_expected.to validate_presence_of(:sha) }
      end
   end
end
