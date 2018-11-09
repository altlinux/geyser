class RecreateRepocopNotes < ActiveRecord::Migration[5.2]
   def change
      rename_table :repocop_patches, :repocop_patches_old

      create_table :repocop_patches, id: false do |t|
         t.primary_key :package_id, comment: "Ссылка на исходный пакет, к которому применима заплатка"
         t.text :text, null: false, comment: "Текст заплатки"

         t.timestamps
      end

      add_foreign_key :repocop_patches, :packages, { on_delete: :cascade }

      change_table :packages do |t|
         t.index %i(name epoch version release), name: :packages_name_epoch_version_release_index
         t.index %i(name epoch version release arch), name: :packages_name_epoch_version_release_arch_index
         t.index %i(name epoch version release buildtime), name: :packages_name_epoch_version_release_buildtime_index # TODO should be unique but is not :.(
         t.index %i(name epoch version release buildtime arch), name: :packages_name_epoch_version_release_buildtime_arch_index
      end

      reversible do |dir|
         dir.up do
            queries = [
               "    WITH t_patches AS (
                  SELECT packages.id AS package_id,
                         repocop_patches_old.url AS text
                    FROM repocop_patches_old
              INNER JOIN packages
                      ON packages.name = repocop_patches_old.name
                     AND packages.version = repocop_patches_old.version
                     AND packages.release = repocop_patches_old.release)
             INSERT INTO repocop_patches
                        (package_id, text, created_at, updated_at)
                  SELECT package_id, text, now(), now()
                    FROM t_patches
             ON CONFLICT (package_id) DO NOTHING"
            ]

            queries.each { |q| ApplicationRecord.connection.execute(q) }

            require 'open-uri'
            valid_ids = RepocopPatch.all.map do |repocop_patch|
               begin
                  text = open(URI.escape(repocop_patch.text)).read
                  repocop_patch.update_attribute(:text, text)
                  repocop_patch.package_id
               rescue OpenURI::HTTPError
               end
            end.compact

            RepocopPatch.where.not(package_id: valid_ids).delete_all
         end
      end
   end
end
