class FixLostSources
   def do
      Package.transaction do
         attrs = Package.src.map do |spkg|
            if spkg.sources.blank? && (filepath = spkg.first_presented_filepath)
               rpm = Rpm::Base.new(filepath)
               Source.prep_attrs(rpm, spkg)
            end
         end.compact.flatten

         Source.import!(attrs)
      end
   end
end
