class BranchAsChangelogSerializer < RecordSerializer
   attributes :name, :count, :slug

   alias_method :_object, :object

   def count
      _object.maintainer_id
   end

   protected

   def object
      @branch ||= Branch.find_by_id(_object.id)
   end
end
