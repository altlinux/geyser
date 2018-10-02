class RemovePackageIdFromGears < ActiveRecord::Migration[5.2]
   def change
      reversible do |dir|
         dir.up do
            remove_column :gears, :package_id
            add_index :gears, %i(repo maintainer_id), unique: true
         end

         dir.down do
            add_column :gears, :package_id, :bigint, comment: "Ссылка на пакет"
            add_index :gears, :package_id
            add_foreign_key :gears, :packages, on_delete: :restrict
            remove_index :gears, %i(repo maintainer_id)
         end
      end
   end
end
