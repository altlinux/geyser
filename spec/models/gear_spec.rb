# frozen_string_literal: true

require 'rails_helper'

describe Gear do
   it { is_expected.to be_a(ApplicationRecord) }

   context 'Validation' do
      it { is_expected.to validate_presence_of(:reponame) }
      it { is_expected.to validate_presence_of(:url) }
      it { is_expected.to validate_presence_of(:changed_at) }
   end

   context 'Scope' do
      it { is_expected.to have_many(:spkgs).with_primary_key(:reponame).with_foreign_key(:name).class_name('Package::Src') }
      it { is_expected.to have_many(:gear_maintainers) }
      it { is_expected.to have_many(:maintainers).through(:gear_maintainers) }
      it { is_expected.to have_many(:srpms).through(:spkgs).class_name('Rpm').source(:rpms) }
      it { is_expected.to have_many(:branch_paths).through(:srpms).source(:branch_path) }
      it { is_expected.to have_many(:branches).through(:branch_paths).source(:branch) }
   end
end
