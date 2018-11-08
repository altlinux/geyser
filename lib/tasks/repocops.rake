# frozen_string_literal: true

namespace :repocop do
   desc 'Import repocop reports to database'
   task update: :environment do
      ImportRepocopReports.new(url: 'http://repocop.altlinux.org/pub/repocop/reports/txt/by-srpm/').do
   end

   desc 'Import repocop patches list to database'
   task patches: :environment do
   end
end
