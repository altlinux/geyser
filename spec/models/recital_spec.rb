# frozen_string_literal: true

require 'rails_helper'

describe Recital do
   it { is_expected.to be_a(ApplicationRecord) }

   context 'Associations' do
      it { is_expected.to belong_to(:maintainer) }
   end

   context 'Attributes' do
      it { is_expected.to accept_nested_attributes_for(:maintainer) }
   end
end
