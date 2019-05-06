class AddTouchedAtToIssues < ActiveRecord::Migration[5.2]
   def change
      change_table :issues do |t|
         t.datetime :touched_at, comment: "Время, когда был обновлён статус отчета об ошибке"
      end

      reversible do |dir|
         dir.up do
            [         "UPDATE issues
                          SET touched_at = issues.reported_at"
            ].each { |q| ApplicationRecord.connection.execute(q) }
         end
      end
   end
end
