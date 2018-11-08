class CreateRepocopNotes < ActiveRecord::Migration[5.2]
   def change
      create_table :repocop_notes do |t|
         t.references :package, null: false, foreign_key: { on_delete: :cascade }, comment: "Ссылка на архитектурный пакет, к которому применима заметка"
         t.integer :status, null: false, index: true, comment: "Короткий статус заметки: заметка, ошибка, предупреждение или опыт"
         t.string :kind, null: false, index: true, comment: "Короткое описание заметки"
         t.string :description, null: false, comment: "Описание заметки"

         t.timestamps

         t.index %i(package_id kind), unique: true
      end

      remove_column :packages, :repocop, :string, default: "skip", comment: "Статус проверки репокопом"

      change_table :packages do |t|
         t.integer :repocop_status, default: 0, index: true, comment: "Статус проверки репокопом"

         t.index %i(src_id)
      end

      reversible do |dir|
         dir.up do
            queries = [
               "    WITH t_notes AS (
                  SELECT packages.id AS package_id,
                         repocops.testname AS kind,
                         repocops.status,
                         repocops.message AS description
                    FROM repocops
              INNER JOIN packages
                      ON packages.name = repocops.name
                     AND packages.version = repocops.version
                     AND packages.release = repocops.release
                     AND packages.arch = repocops.arch)
             INSERT INTO repocop_notes
                        (package_id, kind, status, description, created_at, updated_at)
                  SELECT package_id,
                         kind,
                         CASE
                         WHEN (status = 'skip') THEN 0
                         WHEN (status = 'ok') THEN 1
                         WHEN (status = 'experimental') THEN 2
                         WHEN (status = 'info') THEN 3
                         WHEN (status = 'warn') THEN 4
                         WHEN (status = 'fail') THEN 5
                         ELSE 0
                         END,
                         description,
                         now(),
                         now()
                    FROM t_notes
             ON CONFLICT (package_id, kind) DO NOTHING"
            ]

            queries.each { |q| ApplicationRecord.connection.execute(q) }
         end
      end
   end
end
