class RenameFtbfsInIssues < ActiveRecord::Migration[5.2]
   def change
      rename_column :branch_paths, :ftbfs_url, :ftbfs_stat_uri

      change_table :branch_paths do |t|
         t.string :ftbfs_uri, comment: "Внешная изворная ссылка на ftbfs для источника ветви"
      end

      change_table :issues do |t|
         t.string :log_url, comment: "Пучинная ссылка на лог сборки пакета или иной лог"

         t.datetime :updated_at, comment: "Время последней пересборки пакета"
      end
   end
end
