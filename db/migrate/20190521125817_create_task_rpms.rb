class CreateTaskRpms < ActiveRecord::Migration[5.2]
   def change
      create_table :task_rpms, id: false do |t|
         t.string :md5, index: true, comment: "MD5 сумма файла RPM"
         t.references :task, foreign_key: { on_delete: :cascade }, comment: "Относка к заданию"

         t.index %i(md5 task_id), unique: true
      end
   end
end
