
class AddFtpUrlToBranchPaths < ActiveRecord::Migration[5.2]
   def change
      change_table :branch_paths do |t|
         t.string :ftp_url
      end
   end
end
