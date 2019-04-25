require 'rails_helper'

RSpec.describe ExerciseApprover, type: :model do
  context "Database" do
      it { is_expected.to have_db_column(:approver_slug).of_type(:string).with_options(null: false) }
      it { is_expected.to have_db_column(:exercise_id).of_type(:integer).with_options(null: false) }

      it { is_expected.to have_db_index(:approver_slug) }
      it { is_expected.to have_db_index(:exercise_id) }
   end

   context "Associations" do
      it { is_expected.to belong_to(:exercise) }
      it { is_expected.to belong_to(:approver).class_name('Maintainer').with_primary_key('login').with_foreign_key('approver_slug') }
   end
end
