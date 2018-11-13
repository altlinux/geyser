# frozen_string_literal: true

class RemoveOldRpms
   def do
      Rpm.transaction do
         [
            "  WITH t AS (
             SELECT distinct on(rpms.id)
                    rpms.id, srpms.obsoleted_at
               FROM rpms
          LEFT JOIN packages
                 ON packages.id = rpms.package_id
                AND packages.type = 'Package::Built'
          LEFT JOIN rpms as srpms
                 ON srpms.package_id = packages.src_id
              WHERE rpms.obsoleted_at IS NULL
           ORDER BY rpms.id, srpms.obsoleted_at DESC NULLS FIRST)
             UPDATE rpms
                SET obsoleted_at = now()
               FROM t
              WHERE t.id = rpms.id
                AND t.obsoleted_at IS NOT NULL"
         ].each { |q| Rpm.connection.execute(q) }
      end
   end
end
