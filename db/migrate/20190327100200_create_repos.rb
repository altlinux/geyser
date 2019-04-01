class CreateRepos < ActiveRecord::Migration[5.2]
   def change
      create_table :repos do |t|
         t.string :name, null: false, index: true, comment: 'Имя схова'
         t.string :uri, null: false, index: { unique: true }, comment: 'Внешняя ссылка на схов'
         t.string :path, null: false, index: true, comment: 'Внутренний путь к схову'
         t.string :kind, null: false, index: true, default: 'origin', comment: "Вид ресурса gear, srpm или origin"
         t.string :holder_slug, index: true, comment: "Владелец схова, если определён"
         t.datetime :changed_at, index: true, null: false, default: Time.at(0), comment: "Время последнего обновления схова"
      end
   end
end
