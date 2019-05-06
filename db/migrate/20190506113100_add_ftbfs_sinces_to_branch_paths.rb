class AddFtbfsSincesToBranchPaths < ActiveRecord::Migration[5.2]
   def change
      change_table :branch_paths do |t|
         t.string :ftbfs_stat_since_uri, comment: "Внешняя изворовая ссылка на ресурс с датами первой поломки"
      end
   end
end
