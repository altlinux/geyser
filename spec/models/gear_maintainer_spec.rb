# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GearMaintainer, type: :model do
   it { is_expected.to be_a(ApplicationRecord) }

   context 'Associations' do
      it { is_expected.to belong_to(:maintainer) }
      it { is_expected.to belong_to(:gear) }
   end
end
