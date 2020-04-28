# frozen_string_literal: true

require 'rails_helper'

describe Branch do
   it { is_expected.to be_a(ApplicationRecord) }

   context 'Associations' do
      it { is_expected.to have_many(:branch_paths) }
      it { is_expected.to have_many(:rpms).through(:branch_paths) }
      it { is_expected.to have_many(:packages).through(:branch_paths) }
      it { is_expected.to have_many(:spkgs).through(:rpms).class_name('Package::Src').source(:package) }
      it { is_expected.to have_many(:all_rpms).through(:branch_paths).class_name(:Rpm).source(:rpms) }
      it { is_expected.to have_many(:all_spkgs).through(:all_rpms).class_name('Package::Src').source(:package) }
      it { is_expected.to have_many(:rpm_names).through(:branch_paths).source(:rpms) }
      it { is_expected.to have_many(:srpm_filenames).through(:branch_paths).source(:rpms) }
      it { is_expected.to have_many(:all_packages).through(:all_rpms).class_name(:Package).source(:package) }
      it { is_expected.to have_many(:changelogs).through(:spkgs).source(:changelog) }
      it { is_expected.to have_many(:all_changelogs).through(:all_spkgs).source(:changelogs) }
      it { is_expected.to have_many(:branch_groups).dependent(:destroy) }
      it { is_expected.to have_many(:groups).through(:spkgs) }
      it { is_expected.to have_many(:teams).dependent(:destroy) }
      it { is_expected.to have_many(:mirrors).dependent(:destroy) }
      it { is_expected.to have_many(:ftbfs).class_name('Issue::Ftbfs').through(:branch_paths) }
      it { is_expected.to have_many(:branching_maintainers).dependent(:delete_all) }
      it { is_expected.to have_many(:maintainers).through(:branching_maintainers) }
   end

   context 'Validation' do
      it { is_expected.to validate_presence_of(:slug) }
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:vendor) }
   end

   context '#to_param' do
      subject { create(:branch, name: 'Sisyphus', slug: "sisyphus") }

      specify { expect(subject.to_param).to eq('sisyphus') }
   end

   describe '#arches' do
      subject { create(:branch, arches: %w(i586 x86_64 noarch aarch64 mipsel armh)) }

      specify { expect(subject.arches).to match_array(%w(i586 x86_64 aarch64 mipsel armh)) }
   end
end
