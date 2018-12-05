# frozen_string_literal: true

require 'rails_helper'

describe Issue::Ftbfs do
   it { should be_a(Issue) }

   context 'Validation' do
      it { is_expected.to validate_presence_of(:evr) }
      it { is_expected.to  validate_presence_of(:repo_name) }
      it { is_expected.to  validate_presence_of(:reported_at) }
   end
end
