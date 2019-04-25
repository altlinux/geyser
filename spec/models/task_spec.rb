require 'rails_helper'

RSpec.describe Task, type: :model do
  context "Database" do
      it { is_expected.to have_db_column(:no).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:state).of_type(:string) }
      it { is_expected.to have_db_column(:shared).of_type(:boolean) }
      it { is_expected.to have_db_column(:test).of_type(:boolean) }
      it { is_expected.to have_db_column(:try).of_type(:integer) }
      it { is_expected.to have_db_column(:iteration).of_type(:integer) }
      it { is_expected.to have_db_column(:changed_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:owner_slug).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:branch_path_id).of_type(:integer).with_options(null: false) }
      it { is_expected.to have_db_column(:uri).of_type(:string) }

      it { is_expected.to have_db_index(:branch_path_id) }
      it { is_expected.to have_db_index(:owner_slug) }
      it { is_expected.to have_db_index(:state) }
      it { is_expected.to have_db_index(:no).unique(true) }
   end

   context "Associations" do
      it { is_expected.to have_many(:exercises) }
   end

   context "Validations" do
      it { is_expected.to validate_presence_of(:no) }
      it { is_expected.to validate_presence_of(:state) }
      it { is_expected.to validate_presence_of(:changed_at) }
      it { is_expected.to validate_presence_of(:uri) }
   end
end
