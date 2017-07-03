require 'rails_helper'

describe Repocop do
  it { should be_a(ApplicationRecord) }

  context 'Associations' do
    it { should belong_to(:branch) }

    pending { should belong_to(:srpm) }
  end

  context 'Validation' do
    it { should validate_presence_of(:branch) }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:version) }

    it { should validate_presence_of(:release) }

    it { should validate_presence_of(:arch) }

    it { should validate_presence_of(:srcname) }

    it { should validate_presence_of(:srcversion) }

    it { should validate_presence_of(:srcrel) }

    it { should validate_presence_of(:testname) }
  end

  context 'DB Indexes' do
    it { should have_db_index(:srcname) }

    it { should have_db_index(:srcrel) }

    it { should have_db_index(:srcversion) }
  end

  # it 'should import repocops from url' do
  #   page = File.read('spec/data/prometheus2.sql')
  #   url = 'http://repocop.altlinux.org/pub/repocop/prometheus2/prometheus2.sql'
  #   FakeWeb.register_uri(:get, url, response: page)
  #   expect { Repocop.update_repocop }.to change(Repocop, :count).by(1)
  # end
end
