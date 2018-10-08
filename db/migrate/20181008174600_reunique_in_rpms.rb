class ReuniqueInRpms < ActiveRecord::Migration[5.1]
   def change
      remove_index :rpms, column: %i(branch_path_id filename), name: "index_rpms_on_branch_path_id_and_filename", unique: true
      remove_index :rpms, column: %i(branch_path_id package_id), name: "index_rpms_on_branch_path_id_and_package_id", unique: true
      add_index :rpms, %i(branch_path_id filename package_id obsoleted_at),
                       name: "index_rpms_on_branch_path_id_filename_package_id_obsoleted_at",
                       unique: true
   end
end
