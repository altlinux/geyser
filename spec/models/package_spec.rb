# frozen_string_literal: true

require 'rails_helper'

describe Package do
   it { is_expected.to be_a(ApplicationRecord) }

   context 'DB' do
      it { is_expected.to_not have_db_column(:branch_id) }
      it { is_expected.to_not have_db_column(:filename) }
      it { is_expected.to_not have_db_column(:alias) }
   end

   describe 'Associations' do
      it { is_expected.to belong_to(:group) }
      it { is_expected.to belong_to(:builder).class_name('Maintainer').inverse_of(:rpms).counter_cache(:srpms_count) }

      it { is_expected.to have_many(:rpms).inverse_of(:package) }
      it { is_expected.to have_many(:all_rpms).class_name('Rpm').dependent(:destroy) }
      it { is_expected.to have_many(:branch_paths).through(:rpms) }
      it { is_expected.to have_many(:branches).through(:branch_paths) }
      it { is_expected.to have_many(:repocop_notes) }
   end

   describe 'Validation' do
      it { is_expected.to validate_presence_of(:group) }
      it { is_expected.to validate_presence_of(:md5) }
      it { is_expected.to validate_presence_of(:group) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:builder) }
      it { is_expected.to validate_presence_of(:buildtime) }
      it { is_expected.to validate_presence_of(:arch) }
   end
end
