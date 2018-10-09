namespace :fix do
   desc 'Fix mentioning maintainers in branch'
   task branching_maintainers: %i(environment) do
      FixBranchingMaintainers.new.do
   end

   desc 'Fix lost sources'
   task lost_sources: %i(environment) do
      FixLostSources.new.do
   end

   desc 'Fix changelogs'
   task changelogs: %i(environment) do
      FixChangelogs.new.do
   end
end
