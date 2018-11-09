# frozen_string_literal: true

namespace :repocop do
   desc 'Import repocop reports to database'
   task update: :environment do
      ImportRepocopReports.new(url: 'http://repocop.altlinux.org/pub/repocop/reports/txt/by-srpm/').do
      ImportRepocopPatches.new(url: 'http://repocop.altlinux.org/pub/repocop/reports/diff/by-srpm/').do
   end
end
