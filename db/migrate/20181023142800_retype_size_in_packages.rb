class RetypeSizeInPackages < ActiveRecord::Migration[5.2]
   def change
      change_column :packages, :size, :bigint
   end
end
