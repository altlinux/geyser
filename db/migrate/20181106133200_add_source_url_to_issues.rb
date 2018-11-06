class AddSourceUrlToIssues < ActiveRecord::Migration[5.2]
   def change
      change_table :issues do |t|
         t.string :source_url, comment: "Внешеняя ссылка на пакет-источник вопроса"
      end
   end
end
