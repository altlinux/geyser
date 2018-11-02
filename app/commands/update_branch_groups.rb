class UpdateBranchGroups
   attr_reader :group_ids, :branch_ids

   def do
      branches.find_each do |branch|
         branch_groups = branch.branch_groups.where(group_id: groups.select(:id))

         branch_groups.find_each do |branch_group|
            branch_group.update!(srpms_count: branch_group.srpms.count)
         end
      end
   end

   protected

   def initialize branch_ids: nil, group_ids: nil
      @branches = branch_ids && Branch.where(id: branch_ids) || Branch.all
      @groups = group_ids && Group.where(id: group_ids) || Group.all
   end
end
