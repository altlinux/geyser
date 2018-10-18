class FixGears < ActiveRecord::Migration[5.2]
   def up
      drop_table :gears

      create_table :gears do |t|
         t.string :reponame, null: false, index: true, comment: "Имя пакета"
         t.string :url, null: false, index: { unique: true }, comment: "Внешняя ссылка к ресурсу на сервере"
         t.string :kind, null: false, comment: "Вид ресурса gear или srpm"
         t.datetime :changed_at, null: false, comment: "Время изменения"

         t.timestamps
      end
   end
end
