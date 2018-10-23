class CreateIssues < ActiveRecord::Migration[5.2]
   def change
      create_table :issues do |t|
         t.string :type, index: true, null: false, comment: 'Тип проблемы'
         t.string :no, index: true, null: false, comment: 'Номер проблемы, уникальный в паре с типом'
         t.string :status, index: true, null: false, comment: 'Статус проблемы: новая, разрешена и т.п.'
         t.string :resolution, index: true, comment: 'Описание разрешенности проблемы'
         t.string :severity, index: true, null: false, comment: 'Серьезность проблемы'
         t.references :branch, null: false, foreign_key: { on_delete: :cascade }, comment: 'Ветвь, которой относится проблема'
         t.string :repo_name, index: true, comment: 'RPM-пакет, к которому относится проблема'
         t.string :assigned_to, index: true, null: false, comment: 'Почта назначенного для решения проблемы'
         t.string :reporter, index: true, null: false, comment: 'Почта отчитавшегося о решении проблемы'
         t.text :description, comment: 'Описание проблемы'

         t.index %i(type no), unique: true
      end

      drop_table :bugs, id: :serial, force: :cascade do |t|
         t.integer "bug_id"
         t.string "bug_status", limit: 255
         t.string "resolution", limit: 255
         t.string "bug_severity", limit: 255
         t.string "product", limit: 255
         t.string "component", limit: 255
         t.string "assigned_to", limit: 255
         t.string "reporter", limit: 255
         t.datetime "created_at"
         t.datetime "updated_at"
         t.text "short_desc"
         t.index ["assigned_to"], name: "index_bugs_on_assigned_to"
         t.index ["bug_status"], name: "index_bugs_on_bug_status"
         t.index ["component"], name: "index_bugs_on_component"
         t.index ["product"], name: "index_bugs_on_product"
      end
   end
end
