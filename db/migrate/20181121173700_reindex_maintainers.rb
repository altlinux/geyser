class ReindexMaintainers < ActiveRecord::Migration[5.2]
   def change
     add_index :maintainers, %i(login), name: :index_maintainers_on_login, unique: true
   end
end
