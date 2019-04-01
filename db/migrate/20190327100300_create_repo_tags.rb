class CreateRepoTags < ActiveRecord::Migration[5.2]
   def change
      create_table :repo_tags do |t|
         t.references :repo, null: false, foreign_key: { on_delete: :cascade }, comment: "Ссылка на схов"
         t.references :tag, null: false, foreign_key: { on_delete: :cascade }, comment: "Ссылка на метку"

         t.index %i(repo_id tag_id), unique: true
      end
   end
end
