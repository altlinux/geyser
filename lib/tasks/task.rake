# frozen_string_literal: true

namespace :task do
   desc 'Update all tasks to database'
   task update: :environment do
      ImportTasks.new(sources: [{
                            path: '/tasks',
                            depth: 2,
                         }, {
                            path: '/tasks/archive/done',
                            depth: 3,
                         }]).do
   end
end
