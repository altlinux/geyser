# frozen_string_literal: true

namespace :task do
   desc 'Update all tasks to database'
   task update: :environment do
      ImportTasks.new(sources: [{
                            path: '/tasks',
                            depth: 2,
                            file: "files1.list",
                         }, {
                            path: '/tasks/archive/done',
                            depth: 3,
                            file: "files2.list",
                         }]).do
   end

   desc 'Update all tasks to database'
   task :link, %i(begin end) => %i(environment) do |_, args|
      range = Range.new(args.begin.to_i, args.end.to_i)
      ImportTaskRpms.new(range).do
   end
end
