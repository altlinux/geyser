class FixGroups
   require 'csv'

   NAMES_RU = CSV.read('db/seed/groups.csv', headers: false).to_a.to_h

   def do
      Package.where("groupname ~ '[А-Яа-я]'").find_each do |package|
         package_full_path(package)
      end

      Group.import!(group_attrs, on_duplicate_key_ignore: true)
      BranchGroup.import!(branch_group_attrs, on_duplicate_key_update: {
                                                  conflict_target: %i(id),
                                                  columns: %i(group_id branch_id) })
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

   def branch_group_attrs
      BranchGroup.where.not(name: nil).map do |branch_group|
         path = full_name(branch_group)

         {
            id: branch_group.id,
            branch_id: branch_group.branch_id,
            group_id: Group.find_by_path!(path).id,
         }
      end
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
