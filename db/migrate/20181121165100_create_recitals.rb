class CreateRecitals < ActiveRecord::Migration[5.2]
   def change
      create_table :recitals do |t|
         t.string :address, index: true, null: false, comment: "Адрес общалки"
         t.string :type, index: true, null: false, comment: "Вид общалки"
         t.references :maintainer, foreign_key: { on_delete: :cascade }, null: false, comment: "Отсылка на сопровождающего"
         t.boolean :foremost, default: false, comment: "Первичная общалка"

         t.index %i(address type), unique: true
      end

      add_foreign_key :issue_assignees, :maintainers, on_delete: :restrict
      add_foreign_key :branching_maintainers, :maintainers, on_delete: :cascade

      remove_index :maintainers, column: %i(login), name: :index_maintainers_on_login

      reversible do |dir|
         dir.up do
            queries = [
               "INSERT INTO recitals (address, maintainer_id, type, foremost)
                     SELECT btrim(maintainers.email, '()'),
                            name_ids.id,
                            'Recital::Email',
                            maintainers.email = name_ids.email
                       FROM maintainers
                 INNER JOIN (
            SELECT DISTINCT on(name) name, id, btrim(email, '()') AS email
                       FROM maintainers
                   ORDER BY name) AS name_ids
                         ON name_ids.name = maintainers.name
                ON CONFLICT DO NOTHING"
            ]

            queries.each { |q| ApplicationRecord.connection.execute(q) }

            { 'Dmitry V. Levin (QA)' => 'Dmitry V. Levin',
              'Gleb F-Malinovskiy (qa)' => 'Gleb Fotengauer-Malinovskiy' }.each do |name, to_name|
               maintainer = Maintainer.find_by_name(name)
               main_maintainer = Maintainer.find_by_name(to_name)
               MergeMaintainers.new(source: maintainer, target: main_maintainer).do
            end

            Maintainer.joins(:emails).find_each do |main_maintainer|
               Maintainer.where("email IN (#{main_maintainer.emails.select(:address).to_sql})").each do |maintainer|
                  if maintainer != main_maintainer
                     puts "#{maintainer.name} (#{maintainer.id}) => #{main_maintainer.name} (#{main_maintainer.id})"
                     MergeMaintainers.new(source: maintainer, target: main_maintainer).do
                  end
               end
            end
         end
      end
   end
end
