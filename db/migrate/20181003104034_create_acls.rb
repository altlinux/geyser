class CreateAcls < ActiveRecord::Migration[5.2]
   def change
      create_table :acls do |t|
         t.references :branch_path, foreign_key: true, comment: "Ссылка на путь ветви"
         t.string :maintainer_slug, index: true, comment: "Имя сопровождающего для пакета"
         t.string :package_name, index: true, comment: "Имя пакета"
         t.boolean :owner, comment: "Владелец ли пакета?", default: false

         t.timestamps

         t.index %i(package_name maintainer_slug branch_path_id), unique: true, name: 'index_acls_on_three_fields'
      end

      change_table :branch_paths do |t|
         t.string :acl_url, comment: "Внешняя ссылка на список прав на доступ"
      end

      reversible do |dir|
         require 'open-uri'

         dir.up do
            Branch.find_each do |branch|
               branch_path = branch.branch_paths.src.first

               url = "http://git.altlinux.org/acl/list.packages.#{branch.name.downcase}"

               begin
                  open(URI.escape(url))
               rescue OpenURI::HTTPError
               else
                  branch_path.update!(acl_url: url)
               end
            end
         end
      end
   end
end
