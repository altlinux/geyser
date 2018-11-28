require 'rails_helper'

RSpec.describe Rpm, type: :model do
   it { is_expected.to be_a(ApplicationRecord) }

   context 'DB' do
      it { is_expected.to have_db_column(:branch_path_id) }
      it { is_expected.to have_db_column(:package_id) }
      it { is_expected.to have_db_column(:name) }
      it { is_expected.to have_db_column(:filename) }

      it { is_expected.to have_db_index([:branch_path_id, :filename, :package_id]).unique(true) }
      it { is_expected.to have_db_index(:branch_path_id) }
      it { is_expected.to have_db_index(:package_id) }
      it { is_expected.to have_db_index(:name) }
      it { is_expected.to have_db_index(:filename) }
   end

   context 'Associations' do
      it { is_expected.to belong_to(:branch_path).inverse_of(:rpms) }
      it { is_expected.to belong_to(:package).autosave(true) }

      it { is_expected.to have_one(:branch).through(:branch_path) }
      it { is_expected.to have_one(:builder).through(:package).class_name('Maintainer') }
   end

   context 'Validation' do
      it { is_expected.to validate_presence_of(:branch_path) }
      it { is_expected.to validate_presence_of(:filename) }
   end

   context 'Delegations' do
      it { is_expected.to delegate_method(:evr).to(:package) }
      it { is_expected.to delegate_method(:arch).to(:package) }
   end

   context 'Callbacks' do
      it { is_expected.to callback(:fill_name_in).before(:save) }
   end
end
