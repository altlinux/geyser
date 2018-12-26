

class BranchAsChangelogSerializer < RecordSerializer
   attributes :name, :srpms_count, :slug

   alias_method :_object, :object

   def srpms_count
      _object.maintainer_id
   end

   protected

   def object
      @branch ||= Branch.find_by_id(_object.id)
   end
end
