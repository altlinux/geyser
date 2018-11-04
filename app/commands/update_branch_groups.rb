class UpdateBranchGroups
   attr_reader :group_ids, :branches

   def do
      BranchGroup.import!(branch_group_attrs, on_duplicate_key_update: {
         conflict_target: %i(branch_id group_id),

         columns: %i(srpms_count) })
   end

   protected

   def branch_group_attrs
      branches.map do |branch|
         pre_groups = branch.groups
                            .where(id: group_ids)
                            .select("branch_paths.branch_id, groups.path, packages.group_id")
                            .group("branch_paths.branch_id, groups.path, rpms.package_id, packages.group_id")

         groups = "SELECT t.branch_id, t.path, count(t.group_id) AS cnt FROM (#{pre_groups.to_sql}) AS t GROUP BY t.branch_id, t.path"

         Group.where(id: group_ids)
              .joins("INNER JOIN (#{groups}) AS j ON groups.path @> j.path")
              .select("groups.id AS group_id, j.branch_id, SUM(j.cnt) AS srpms_count")
              .group("groups.id, j.branch_id").as_json
      end.flatten
   end

   def initialize branch_ids: nil, group_ids: nil
      @branches = branch_ids && Branch.where(id: branch_ids) || Branch.all
      @group_ids = group_ids || Group.select(:id)
   end
end
