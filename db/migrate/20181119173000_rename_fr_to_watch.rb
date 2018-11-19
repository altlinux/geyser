class RenameFrToWatch < ActiveRecord::Migration[5.2]
   def change
      reversible do |dir|
         dir.up do
            queries = [
               "     UPDATE issues
                        SET type = 'Issue::Watch'
                      WHERE issues.type = 'Issue::FeatureRequest'"
            ]

            queries.each { |q| ApplicationRecord.connection.execute(q) }
         end
      end
   end
end
