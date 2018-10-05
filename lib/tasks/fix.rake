namespace :fix do
   desc 'Fix mentioning maintainers in branch'
   task branching_maintainers: %i(environment) do
      FixBranchingMaintainers.new.do
   end
end
