class CreateExercises < ActiveRecord::Migration[5.2]
   def change
      create_table :exercises do |t|
         t.integer :no, null: false, index: true, comment: 'Число задачи в задании'
         t.string :kind, null: false, comment: 'Вид задания' # if blank: skip
         t.string :pkgname, null: false, index: true, comment: 'Имя пакета для задания' # < pkgname | package
         t.string :resource, index: true, comment: 'Имя исходного сбора или ресурс исходников для задания'
         t.string :sha, index: true, comment: 'Хеш соборочный для задания'
         t.string :committer_slug, null: false, index: true, comment: "Автор воплета задания"
         t.references :task, null: false, foreign_key: { on_delete: :restrict }, comment: "Ссылка на задачу"

         t.index %i(task_id no), unique: true
      end
   end
end
