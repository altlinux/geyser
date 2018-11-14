class RetypeSizeInSources < ActiveRecord::Migration[5.2]
   def change
      rename_column :sources, :size, :old_size

      change_table :sources do |t|
         t.bigint :size, comment: "Размер исходника"
      end

      reversible do |dir|
         dir.up do
            queries = [
               "    UPDATE sources
                       SET size = sources.old_size"
            ]

            queries.each { |q| ApplicationRecord.connection.execute(q) }
         end
      end

      remove_column :sources, :old_size, :integer
   end
end
