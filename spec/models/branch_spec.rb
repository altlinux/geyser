# frozen_string_literal: true

require 'rails_helper'

describe Branch do
  it { should be_a(ApplicationRecord) }

  it { should be_a(Redis::Objects) }

  it { should have_many(:srpms).through(:named_srpms) }

  it { should have_many(:branch_paths) }

  it { should have_many(:named_srpms).through(:branch_paths) }

  it { should have_many(:srpms).through(:named_srpms) }

  it { should have_many(:changelogs).through(:srpms) }

  it { should have_many(:packages).through(:srpms) }

  it { should have_many(:groups).dependent(:destroy) }

  it { should have_many(:teams).dependent(:destroy) }

  it { should have_many(:mirrors).dependent(:destroy) }

  it { should have_many(:patches).through(:srpms) }

  it { should have_many(:sources).through(:srpms) }

  it { should have_many(:ftbfs).class_name('Ftbfs').dependent(:destroy) }

  it { should have_many(:repocops).dependent(:destroy) }

  it { should have_many(:repocop_patches).dependent(:destroy) }

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:vendor) }

  describe '#counter' do
    subject { create(:branch) }

    specify { expect(subject.counter).to be_a(Redis::Counter) }
  end

  it { should callback(:set_default_counter_value).after(:commit).on(:create) }

  it { should callback(:destroy_counter).after(:commit).on(:destroy) }

  describe '#to_param' do
    subject { create(:branch, name: 'Sisyphus') }

    specify { expect(subject.to_param).to eq('Sisyphus') }
  end

  describe '#arches' do
    subject { create(:branch, :with_paths, arches: %w(i586 x86_64 noarch aarch64 mipsel arm armh)) }

    specify { expect(subject.arches).to match_array(%w(i586 x86_64 aarch64 mipsel armh arm)) }
  end

  # private methods

  describe '#set_default_counter_value' do
    subject { create(:branch) }

    specify { expect(subject.counter.value).to eq(0) }

    # TODO: move to srpm_spec.rb
    # context 'counter should be eq srpms.count' do
    #   let!(:branch) { create(:branch) }
    #
    #   let!(:srpm1) { create(:srpm, branch: branch) }
    #
    #   let!(:srpm2) { create(:srpm, branch: branch) }
    #
    #   let!(:srpm3) { create(:srpm, branch: branch) }
    #
    #   specify { expect(branch.counter.value).to eq(branch.srpms.count) }
    # end
  end

  describe '#destroy_counter' do
    subject { create(:branch) }

    specify { expect { subject.destroy }.to change { Redis.current.get("branch:#{ subject.id }:counter") }.from('0').to(nil) }
  end
end
