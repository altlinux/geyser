require 'rails_helper'

RSpec.describe RepocopNote, type: :model do
   it { is_expected.to be_an(ApplicationRecord) }

   it { is_expected.to belong_to(:package) }

   it { is_expected.to validate_presence_of(:status) }
   it { is_expected.to validate_presence_of(:kind) }
   it { is_expected.to validate_presence_of(:description) }
   it { is_expected.to validate_presence_of(:package_id) }

   it { is_expected.to delegate_method(:fullname).to(:package).with_prefix(true) }
   it { is_expected.to delegate_method(:arch).to(:package).with_prefix(true) }
end
