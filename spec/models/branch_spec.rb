require 'rails_helper'

describe Branch do
  describe 'Validation' do
    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:vendor) }
  end

  describe 'Associations' do
    it { should have_many(:srpms) }

    it { should have_many(:changelogs).through(:srpms) }

    it { should have_many(:packages).through(:srpms) }

    it { should have_many(:groups) }

    it { should have_many(:teams) }

    it { should have_many(:mirrors) }

    it { should have_many(:patches).through(:srpms) }

    it { should have_many(:sources).through(:srpms) }

    it { should have_many(:ftbfs).class_name('Ftbfs') }

    it { should have_many(:repocops) }

    it { should have_many(:repocop_patches) }
  end

  describe 'Callbacks' do
    it { should callback(:set_default_counter_value).after(:create) }

    it { should callback(:destroy_counter).after(:destroy) }
  end

  describe '#to_param' do
    subject { stub_model Branch, name: 'Sisyphus' }

    its(:to_param) { should eq('Sisyphus') }
  end

  it 'should recount Branch#srpms on #recount! and save' do
    branch = create(:branch)
    branch.counter.value = 42
    expect(branch.counter.value).to eq(42)
    branch.recount!
    expect(branch.counter.value).to eq(0)
  end

  # private methods

  describe '#set_default_counter_value' do
    subject { stub_model Branch }

    before do
      expect(subject).to receive(:counter) do
        double.tap do |a|
          expect(a).to receive(:value=).with(0)
        end
      end
    end

    specify { expect { subject.send(:set_default_counter_value) }.not_to raise_error }
  end

  describe '#destroy_counter' do
    subject { stub_model Branch, id: 14 }

    before do
      expect(Redis).to receive(:current) do
        double.tap do |a|
          expect(a).to receive(:del).with("branch:#{ subject.id }:counter")
        end
      end
    end

    specify { expect { subject.send(:destroy_counter) }.not_to raise_error }
  end
end
