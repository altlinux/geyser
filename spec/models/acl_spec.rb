require 'rails_helper'

RSpec.describe Acl, type: :model do
   it { is_expected.to be_a(ApplicationRecord) }

   context 'Associations' do
      it { is_expected.to belong_to(:branch_path) }
      xit { is_expected.to belong_to(:maintainer).with_primary_key(:maintainer_slug).with_foreign_key(:login).optional }

      it { is_expected.to have_one(:branch).through(:branch_path) }
   end
end
