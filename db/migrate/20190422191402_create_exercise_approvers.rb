class CreateExerciseApprovers < ActiveRecord::Migration[5.2]
   def change
      create_table :exercise_approvers do |t|
         t.references :exercise, null: false, foreign_key: { on_delete: :restrict }, comment: "Ссылка на задание"
         t.string :approver_slug, null: false, index: true, comment: "Ссылка на заверщика задания"

         t.index %i(exercise_id approver_slug), unique: true
      end
   end
end
