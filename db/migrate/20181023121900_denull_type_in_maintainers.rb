class DenullTypeInMaintainers < ActiveRecord::Migration[5.2]
   def change
      Maintainer.where("type IS NULL AND email !~* '@packages'").update_all(type: 'Maintainer::Person')
      Maintainer.where("type IS NULL AND email ~* '@packages.'").update_all(type: 'Maintainer::Team')

      change_column_null :maintainers, :type, false
   end
end
