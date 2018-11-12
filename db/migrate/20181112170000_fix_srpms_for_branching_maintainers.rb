class FixSrpmsForBranchingMaintainers < ActiveRecord::Migration[5.2]
   def change
      branch_ids = Branch.where(slug: ['p8','c7','c8','c8_1','c7_1','c7','c6',]).select(:id)
      BranchingMaintainer.where(branch_id: branch_ids).find_each {|bm| bm.update_count! }
   end
end
