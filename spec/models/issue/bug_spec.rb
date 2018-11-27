# frozen_string_literal: true

require 'rails_helper'

describe Issue::Bug do
   it { should be_a(Issue) }

   describe 'Validations' do
      it { is_expected.to validate_numericality_of(:no).only_integer }
   end
end
