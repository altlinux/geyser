class CreateBranchGroups < ActiveRecord::Migration[5.2]
   require 'csv'

   NAMES_RU = CSV.read('db/seed/groups.csv', headers: false).to_a.to_h

   def change
      enable_extension :ltree
      enable_extension :btree_gist

      rename_table :groups, :branch_groups

      create_table :groups do |t|
         t.ltree :path, null: false, comment: "Полный путь группы"
         t.string :slug, null: false, comment: "Плашка группы"
         t.string :name, null: false, comment: "Наименование группы"
         t.string :name_en, null: false

         t.index %i(slug), unique: true
         t.index %i(path), using: :gist, name: :gist_index_groups_on_path
         t.index %i(path)
      end

      change_table :branch_groups do |t|
         t.references :group, foreign_key: { on_delete: :cascade }, comment: "Ссылка на группу"
      end

      change_column_null :packages, :group_id, false

      reversible do |dir|
         dir.up do
            Group.connection.schema_cache.clear!
            Group.reset_column_information
            Group.import!(group_attrs, on_duplicate_key_ignore: true)

            queries = [
              "DELETE
                 FROM branch_groups
                WHERE branch_groups.group_id IS NULL",
              "UPDATE packages
                  SET group_id = branch_groups.group_id
                 FROM branch_groups
                WHERE packages.group_id = branch_groups.id",
              "DELETE
                 FROM branch_groups a
                USING branch_groups b
                WHERE a.id > b.id
                  AND a.branch_id = b.branch_id
                  AND a.group_id = b.group_id"
            ]
            queries.each { |q| Branch.connection.execute(q) }

            Package.where.not(group_id: Group.select(:id)).find_each do |package|
               path = package_full_path(package)
               package.update_attribute(:group_id, Group.where(path: path).select(:id).first.id)
            end
         end
      end

      change_table :branch_groups do |t|
         t.index %i(branch_id group_id), unique: true
      end

      add_foreign_key :packages, :groups, on_delete: :restrict
      change_column_null :branch_groups, :group_id, false

      UpdateBranchGroups.new.do

      # TODO remove groupname of packages
      # TODO remove name, parent_id, lft, rgt of branch_groups
   end

   protected

   def package_full_path package
      names_un = package.read_attribute(:groupname).split('/')
      names_en = names_un.map do |name_un|
         name_en = /[А-Яа-я]/ !~ name_un && name_un || NAMES_RU[name_un]
         name_en.gsub(/[\s\-\+]+/, '_').downcase
      end

      names_en.join('.')
   end

   def full_name branch_group
      name_un = branch_group.read_attribute(:name)
      name_en = /[А-Яа-я]/ !~ name_un && name_un || NAMES_RU[name_un]
      full = name_en.gsub(/[\s\-\+]+/, '_')
      parent = BranchGroup.find_by_id(branch_group.parent_id)

      while parent
         name_un = parent.read_attribute(:name)
         name_en = /[А-Яа-я]/ !~ name_un && name_un || NAMES_RU[name_un]
         full = "#{name_en.gsub(/[\s\-\+]+/, '_')}.#{full}"
         parent = BranchGroup.find_by_id(parent.parent_id)
      end

      full.downcase
   end

   def group_attrs
      names = NAMES_RU.invert
      groups = IO.read('/usr/lib/rpm/GROUPS')

      attrs = (groups.split("\n").map do |group|
         path = group.gsub(/[\s\.\-\+]+/, '_').gsub(/\//, '.').downcase
         name_en = group.split("/").last

         {
            path: path,
            slug: path.downcase.gsub(/\./, '_'),
            name: names[name_en],
            name_en: name_en,
         }
      end | BranchGroup.where.not(name: nil).map do |branch_group|
         path = full_name(branch_group)
         name_un = branch_group.read_attribute(:name)
         name_en = /[А-Яа-я]/ !~ name_un && name_un || NAMES_RU[name_un]

         {
            path: path,
            slug: path.downcase.gsub(/\./, '_'),
            name: names[name_en],
            name_en: name_en,
         }
      end | Package.where.not(group_id: BranchGroup.select(:id)).map do |package|
         path = package_full_path(package)
         name_un = package.read_attribute(:groupname).split("/").last
         name_en = /[А-Яа-я]/ !~ name_un && name_un || NAMES_RU[name_un]

         {
            path: path,
            slug: path.downcase.gsub(/\./, '_'),
            name: names[name_en],
            name_en: name_en,
         }
      end).uniq
   end
end
