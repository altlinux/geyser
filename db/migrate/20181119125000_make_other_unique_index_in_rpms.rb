class MakeOtherUniqueIndexInRpms < ActiveRecord::Migration[5.2]
   def change
      remove_index :rpms, column: %i(branch_path_id filename package_id obsoleted_at),
                          name: :index_rpms_on_branch_path_id_filename_package_id_obsoleted_at

      reversible do |dir|
         dir.up do
            queries = [
               "     DELETE FROM rpms a
                           USING rpms b
                           WHERE a.id < b.id
                             AND a.branch_path_id = b.branch_path_id
                             AND a.filename = b.filename
                             AND a.package_id = b.package_id"
            ]

            queries.each { |q| ApplicationRecord.connection.execute(q) }
         end
      end

      add_index :rpms, %i(branch_path_id filename package_id), unique: true
   end
end
