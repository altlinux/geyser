class RenameWatchToNovelty < ActiveRecord::Migration[5.2]
   def change
      reversible do |dir|
         dir.up do
            queries = [
               "     UPDATE issues
                        SET type = 'Issue::Novelty'
                      WHERE issues.type = 'Issue::Watch'"
            ]

            queries.each { |q| ApplicationRecord.connection.execute(q) }
         end
      end
   end
end
