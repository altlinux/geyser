# frozen_string_literal: true

require 'rails_helper'

describe RepocopPatch do
   it { is_expected.to be_a(ApplicationRecord) }

   context 'Associations' do
      it { is_expected.to belong_to(:package).class_name('Package::Src') }
   end

   context 'Validation' do
     it { is_expected.to validate_presence_of(:text) }
   end
end
