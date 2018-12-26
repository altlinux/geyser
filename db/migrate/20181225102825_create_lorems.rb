class CreateLorems < ActiveRecord::Migration[5.2]
   def change
      create_table :lorems do |t|
         t.text :text, null: false, comment: "Текст"
         t.string :codepage, null: false, index: true, comment: "Кодовая страница текста"
         t.references :package, null: false, foreign_key: true, index: true, comment: "Указатель на пакет"
         t.string :type, null: false, index: true, comment: "Род текста"

         t.timestamps
      end
   end
end
