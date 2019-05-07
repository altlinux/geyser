class AddArchiveUriToBranches < ActiveRecord::Migration[5.2]
   def change
      change_table :branches do |t|
         t.string :archive_uri, comment: "Внешняя ссылка на ссылку списка архивов заданий для ветви"
      end
   end
end
