class ExerciseApprover < ApplicationRecord
   belongs_to :exercise
   belongs_to :approver, class_name: 'Maintainer', primary_key: :login, foreign_key: :approver_slug
end
