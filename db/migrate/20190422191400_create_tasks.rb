class CreateTasks < ActiveRecord::Migration[5.2]
   def change
      create_table :tasks do |t|
         t.integer :no, null: false, index: { unique: true }, comment: 'Число задания сборочницы'
         t.string :uri, comment: "Ссылка на задание"
         t.string :state, index: true, comment: "Статус задания"
         t.boolean :shared, comment: "Разделяемое задание"
         t.boolean :test, comment: "Тестовое задание"
         t.integer :try, comment: "Попытка"
         t.integer :iteration, comment: "Шаг"
         t.string :owner_slug, null: false, index: true, comment: "Учётка владельца"
         t.references :branch_path, null: false, foreign_key: { on_delete: :restrict }, comment: "Ссылка на сборочный путь ветви"
         t.datetime :changed_at, null: false, comment: "Задание изменено в"

         t.timestamps
      end
   end
end
