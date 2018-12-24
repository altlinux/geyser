# frozen_string_literal: true

namespace :gear do
   desc 'Update all git repos to database'
   task update: :environment do
      ImportGears.new(url: 'http://git.altlinux.org', path: '/archive_git').do
   end

   desc 'Update all git repos to database'
   task people: :environment do
      ImportRepos.new(url: 'http://git.altlinux.org', path: '/people').do
   end
end
