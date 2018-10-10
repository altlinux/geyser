class RpmSerializer < RecordSerializer
   attributes :pure_name, :evr, :path_name

   def path_name
      object.branch_path.name
   end

   def pure_name
      object.name
   end

   def evr
      object.package.evr
   end
end
