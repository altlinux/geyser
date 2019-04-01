class CreateTags < ActiveRecord::Migration[5.2]
   def change
      create_table :tags do |t|
         t.string :sha, null: false, index: { unique: true }, comment: 'Хеш метки'
         t.string :name, index: true, comment: "Имя метки"
         t.boolean :alt, comment: "Метка альтовая"
         t.boolean :signed, comment: "Метка подписана"
         t.datetime :authored_at, null: false,index: true, comment: "Воплетено в..."
         t.datetime :tagged_at, index: true, comment: "Помечено в..."
         t.references :author, null: false, foreign_key: { to_table: :maintainers, on_delete: :restrict }, comment: "Воплетчик"
         t.references :tagger, foreign_key: { to_table: :maintainers, on_delete: :restrict }, comment: "Опометчик"
         t.text :message, comment: "Текст воплета метки"

         t.timestamps
      end
   end
end
