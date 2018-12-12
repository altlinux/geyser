class FixMaintainerEmails < ActiveRecord::Migration[5.2]
   def change
      {
          "real.altlinux.org@gmail.com" => "Eugeny A. Rostovtsev",
          "Eugeny A. Rostovtsev (REAL)" => "Eugeny A. Rostovtsev"
      }.each do |name, to_name|
         maintainer = Maintainer.find_by_name(name)
         main_maintainer = Maintainer.find_by_name(to_name)

         if main_maintainer && maintainer
            MergeMaintainers.new(source: maintainer, target: main_maintainer).do
         end
      end

      m_ids = Maintainer.joins(:email).select(:id)
      Maintainer.where.not(id: m_ids).each { |m| m.emails.first.update_attribute(:foremost, true) }
   end
end
