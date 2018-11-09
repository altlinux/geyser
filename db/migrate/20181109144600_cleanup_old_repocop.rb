class CleanupOldRepocop < ActiveRecord::Migration[5.2]
   def change
      drop_table :repocops
      drop_table :repocop_patches_old
   end
end
