# frozen_string_literal: true

namespace :gear do
   desc 'Update all git repos to database'
   task update: :environment do
      ImportGears.new(url: 'http://git.altlinux.org', path: '/archive_git').do
   end
end
