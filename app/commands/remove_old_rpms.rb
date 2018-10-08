# frozen_string_literal: true

class RemoveOldRpms
   def do
      Branch.transaction do
         [
            "UPDATE rpms as a 
                SET obsoleted_at = NOW()
               FROM packages as c, rpms as b
              WHERE c.id = a.package_id 
                AND c.type = 'Package::Built'
                AND b.package_id = c.src_id
                AND a.obsoleted_at IS NULL
                AND b.obsoleted_at IS NOT NULL"
         ].each { |q| Branch.connection.execute(q) }
      end
   end
end
