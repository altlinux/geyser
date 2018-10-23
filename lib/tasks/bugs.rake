# frozen_string_literal: true

namespace :bugs do
   desc 'Import all bugs to database'
   task update: %i(environment) do
      ImportBugs.new('https://bugzilla.altlinux.org/buglist.cgi?ctype=csv').do
   end
end
