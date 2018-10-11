class CleanupChangelogs < ActiveRecord::Migration[5.2]
   def change
      reversible do |dir|
         dir.up do
            FixChangelogs.new.do
         end
      end

      remove_column :changelogs, :changelogtime, :string
      change_column_null :changelogs, :at, false
      change_column_null :changelogs, :evr, false
      change_column_null :changelogs, :package_id, false

      add_foreign_key :changelogs, :maintainers, on_delete: :nullify
   end
end
