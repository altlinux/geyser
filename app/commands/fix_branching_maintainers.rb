class FixBranchingMaintainers
   def do
      ApplicationRecord.transaction do
         Maintainer.find_each do |maintainer|
            Branch.find_each do |branch|
               BranchingMaintainer.find_or_initialize_by(maintainer: maintainer, branch: branch).update_count!
            end
         end
      end
   end
end
