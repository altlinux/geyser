# frozen_string_literal: true

namespace :repo do
   desc 'Update gear repos to database'
   task gears: :environment do
      ImportRepos.new(url: 'http://git.altlinux.org', path: '/gears', scope: :gear, depth: 2).do
   end

   desc 'Update srpm repos to database'
   task srpms: :environment do
      ImportRepos.new(url: 'http://git.altlinux.org', path: '/srpms', scope: :srpm, depth: 2).do
   end

   desc 'Update personal git repos to database'
   task people: :environment do
      ImportRepos.new(url: 'http://git.altlinux.org', path: '/people', scope: :person, depth: 3).do
   end
end
