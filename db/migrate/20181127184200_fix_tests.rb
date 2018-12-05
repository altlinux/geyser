class FixTests < ActiveRecord::Migration[5.2]
   def change
      change_column_null :maintainers, :email, true
   end
end
