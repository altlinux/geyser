class FixExercisesLinkage < ActiveRecord::Migration[5.2]
   def change
      remove_foreign_key :exercises, to_table: :tasks, on_delete: :restrict
      add_foreign_key :exercises, :tasks, on_delete: :cascade
   end
end
