require 'rails_helper'

describe Ftbfs do
  it { should be_a(ApplicationRecord) }

  context 'Associations' do
    it { should belong_to(:branch) }

    it { should belong_to(:maintainer) }
  end

  context 'Validation' do
    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:version) }

    it { should validate_presence_of(:release) }

    it { should validate_presence_of(:weeks) }

    it { should validate_presence_of(:arch) }
  end

  context 'DB Indexes' do
    it { should have_db_index(:branch_id) }

    it { should have_db_index(:maintainer_id) }
  end
end
