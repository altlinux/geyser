# frozen_string_literal: true

namespace :update do
   desc 'Update all the branches'
   task branches: %i(environment) do
      Branch.find_each do |branch|
         puts "#{ Time.zone.now }: import all src rpms from #{branch.name} branch to database"
         Package::Src.import_all(branch)

         puts "#{ Time.zone.now }: import all built rpms from #{branch.name} branch to database"
         Package::Built.import_all(branch)

         puts "#{ Time.zone.now }: import all acls for #{branch.name} branch to database"
         ImportAcls.new(branch: branch).do

         puts "#{ Time.zone.now }: import all groups for #{branch.name} branch to database"
         ImportTeams.new(branch: branch).do
      end
   end

   desc 'Remove lost srpms'
   task :lost, %i(remove) => %i(environment) do |t, args|
      remove = args[:remove] == "true"

      Branch.find_each do |branch|
         puts "#{ Time.zone.now }: remove lost *.src.rpm from #{branch.name} branch"

         branch.branch_paths.src.active.each do |branch_path|
            BranchPath.transaction do
               if !File.directory?(branch_path.path)
                  puts "Folder #{branch_path.path} doesn't exist"
                  next
               end

               if remove
                  RemoveOldSrpms.call(branch_path) do
                     on(:ok) { puts "#{ Time.zone.now }: Old srpms removed" }
                  end
               else
                  count = RemoveOldSrpms.new(branch_path).count

                  puts "#{count} source packages are to remove for #{branch_path.name}"
               end
            end
         end

         RemoveOldRpms.new.do
      end
  end

  desc 'Drop imported at counter for specific branch'
  task :drop_counter, %i(branch_path) => %i(environment) do |t, args|
    puts "#{ Time.zone.now }: Drop updated counter for #{args[:branch_path]}"

    BranchPath.transaction do
       BranchPath.where(name: args[:branch_path]).update_all(imported_at: Time.at(0))
    end
  end

  desc 'Update branch groups'
  task :branch_groups, %i(environment) do
    UpdateBranchGroups.new.do
  end
end
