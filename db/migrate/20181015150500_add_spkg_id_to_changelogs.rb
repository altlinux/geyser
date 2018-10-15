class AddSpkgIdToChangelogs < ActiveRecord::Migration[5.1]
   def change
      change_table :changelogs do |t|
         t.references :spkg, foreign_key: { to_table: :packages }, comment: "Ссылка на исходный пакет, в котором проведены изменения"
      end
   end
end
