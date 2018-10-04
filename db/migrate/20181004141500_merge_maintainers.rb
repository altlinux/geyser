class MergeMaintainers < ActiveRecord::Migration[5.2]
   def change
      change_table :maintainers do |t|
         t.string :type, index: true, comment: "Вид сопровождающего: человек или команда"

         t.index :login, unique: true
         t.index :email, unique: true
      end

      create_table :team_people, id: :serial, force: :cascade do |t|
         t.string :person_slug, index: true, null: false, foreign_key: { to_table: :maintainers, on_delete: :cascade }, comment: "Ссылка на сопровождающего в команде"
         t.string :team_slug, index: true, null: false, foreign_key: { to_table: :maintainers, on_delete: :cascade }, comment: "Ссылка на сопровождающую команду"
         t.references :branch_path, null: false, foreign_key: { on_delete: :cascade }, comment: "Ссылка на путь ветви"
         t.index %i(team_slug person_slug branch_path_id), unique: true, name: "index_team_people_on_three_fields"
      end

      change_table :branch_paths do |t|
         t.string :team_url, comment: "Внешняя ссылка на список групп ветви"
      end

      reversible do |dir|
         dir.up do
            [
                    "UPDATE maintainer_teams
                        SET login = '@' || maintainer_teams.login
                      WHERE maintainer_teams.login !~ '^@.*'",
                    "UPDATE maintainers
                        SET type = 'Maintainer::Person'",
               "DELETE FROM maintainer_teams m1
                      USING maintainer_teams m2
                      WHERE m1.id > m2.id
                       AND (m1.login = m2.login
                         OR m1.email = m2.email)",
               "INSERT INTO maintainers
                           (name, email, login, updated_at, created_at, type)
                     SELECT name, email, login, updated_at, created_at, 'Maintainer::Team'
                       FROM maintainer_teams",
            ].each { |q| Branch.connection.execute(q) }

            drop_table :maintainer_teams

            require 'open-uri'

            Branch.find_each do |branch|
               branch_path = branch.branch_paths.src.first

               url = "http://git.altlinux.org/acl/list.groups.#{branch.name.downcase}"

               begin
                  open(URI.escape(url))
               rescue OpenURI::HTTPError
               else
                  branch_path.update!(team_url: url)
               end
            end
         end

         dir.down do
            create_table :maintainer_teams, id: :serial, force: :cascade do |t|
               t.string :name, limit: 255, null: false
               t.string :email, limit: 255, null: false
               t.string :login, limit: 255, null: false

               t.timestamps
            end

            [
               "INSERT INTO maintainer_teams
                           (name, email, login, updated_at, created_at)
                     SELECT name, email, login, updated_at, created_at
                       FROM maintainers
                      WHERE maintainers.login ~ '^@.*'",
               "DELETE FROM maintainers
                      WHERE maintainers.login ~ '^@.*'",
            ].each { |q| Branch.connection.execute(q) }
         end
      end
   end
end
