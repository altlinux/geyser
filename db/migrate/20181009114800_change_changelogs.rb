class ChangeChangelogs < ActiveRecord::Migration[5.2]
   def change
      change_column_null :maintainers, :login, true

      change_table :changelogs do |t|
         t.references :maintainer, null: true, comment: "Автор изменения в логе"
         t.string :evr, comment: "Эпоха, версия и релиз"
         t.text :text, comment: "Текст изменений"
         t.timestamp :at, comment: "Время создания записи в логе"
      end
   end
end
