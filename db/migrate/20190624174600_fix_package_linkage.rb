class FixPackageLinkage < ActiveRecord::Migration[5.1]
   def change
      reversible do |dir|
         dir.up do
            queries = [
               "   WITH package_pairs AS (
                 SELECT DISTINCT ON (pkgs.id, nspkgs.id)
                        pkgs.id AS pkg_id, nspkgs.id AS spkg_id, branch_paths.name
                   FROM packages AS pkgs
             INNER JOIN rpms
                     ON rpms.package_id = pkgs.id
             INNER JOIN branch_paths
                     ON branch_paths.id = rpms.branch_path_id
             INNER JOIN packages AS spkgs
                     ON spkgs.id = pkgs.src_id
                    AND spkgs.type = 'Package::Src'
             INNER JOIN packages AS nspkgs
                     ON nspkgs.name = spkgs.name
                    AND nspkgs.version = spkgs.version
                    AND nspkgs.release = spkgs.release
                    AND nspkgs.id <> spkgs.id
                    AND nspkgs.type = 'Package::Src'
             INNER JOIN rpms AS srpms
                     ON srpms.package_id = spkgs.id
             INNER JOIN rpms AS nsrpms
                     ON nsrpms.package_id = nspkgs.id
                    AND nsrpms.branch_path_id = branch_paths.source_path_id
                  WHERE nsrpms.branch_path_id <> srpms.branch_path_id
                    AND pkgs.buildtime >= spkgs.buildtime
                    AND pkgs.type = 'Package::Built'
                    AND nsrpms.obsoleted_at IS NULL AND rpms.obsoleted_at IS NULL
               ) UPDATE packages
                    SET src_id = package_pairs.spkg_id
                   FROM package_pairs
                  WHERE package_pairs.pkg_id = packages.id"
            ]

            queries.each { |q| Branch.connection.execute(q) }
         end
      end
   end
end
