class AddFtbfsToIssues < ActiveRecord::Migration[5.2]
   def change
      create_table :issue_assignees do |t|
         t.references :issue, null: false, comment: "Ссылка на вопрос"
         t.references :maintainer, null: false, comment: "Ссылка на сопроводителя вопроса"

         t.index %i(issue_id maintainer_id), unique: true
      end

      change_table :branch_paths do |t|
         t.string :ftbfs_url, comment: "Ссылка в пучине на ftbfs для источника ветви"
         t.boolean :primary, null: false, default: false, comment: "Первичный источник пакетов для ветви"
      end

      change_table :issues do |t|
         t.string :evr, comment: "Эпоха, справа, выпуск пакета"
         t.datetime :reported_at, comment: "Время, когда был получен отчет об ошибке"
         t.datetime :resolved_at, index: true, comment: "Время разрешения вопроса"
         t.references :branch_path, foreign_key: { on_delete: :cascade }, comment: "Ссылка на источник ветви, к которой относится вопрос"
      end

      reversible do |dir|
         dir.up do
            Branch.find_each do |b|
               b.branch_paths.src.order(srpms_count: :desc).first.update_attribute(:primary, true)
            end

            [ "          WITH tmp AS (
                       SELECT DISTINCT issues.assigned_to AS email
                         FROM issues
                        WHERE issues.type IN ('Issue::Bug')
                          AND issues.assigned_to NOT IN (
                       SELECT maintainers.email FROM maintainers))
                  INSERT INTO maintainers
                             (email, name, type, created_at, updated_at)
                       SELECT tmp.email, tmp.email, 'Maintainer::Person', now(), now()
                         FROM tmp",
               "         WITH tmp AS (
                       SELECT DISTINCT(issues.id) AS issue_id, maintainers.id AS maintainer_id
                         FROM issues, maintainers
                        WHERE issues.assigned_to = maintainers.email)
                  INSERT INTO issue_assignees
                             (issue_id, maintainer_id)
                       SELECT tmp.issue_id, tmp.maintainer_id
                         FROM tmp",
                      "UPDATE issues
                          SET branch_path_id = branch_paths.id
                         FROM branch_paths
                        WHERE branch_paths.branch_id = issues.branch_id
                          AND branch_paths.primary = TRUE"
            ].each { |q| ApplicationRecord.connection.execute(q) }
         end
      end

      change_column_null :issues, :branch_path_id, false
      change_column_null :maintainers, :email, false
      remove_column :issues, :branch_id, type: :integer, index: true, null: false, comment: "Ветвь, к которой относится вопрос"
      remove_column :issues, :assigned_to, type: :string, index: true, null: false, comment: "Почта назначенного для решения вопроса"
      add_foreign_key :issue_assignees, :issues, on_delete: :cascade
   end
end
