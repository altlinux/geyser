class DropGears < ActiveRecord::Migration[5.2]
   def change
      drop_table :gear_maintainers
      drop_table :gears
   end
end
