# frozen_string_literal: true

namespace :repo do
   desc 'Update gear repos to database'
   task :gears, %i(force) => %i(environment) do |t, args|
      force = args[:force] =~ /true|force/

      ImportRepos.new(url: 'http://git.altlinux.org', path: '/gears', scope: :gear, depth: 2, force: force).do
   end

   desc 'Update srpm repos to database'
   task :srpms, %i(force) => %i(environment) do |t, args|
      force = args[:force] =~ /true|force/

      ImportRepos.new(url: 'http://git.altlinux.org', path: '/srpms', scope: :srpm, depth: 2, force: force).do
   end

   desc 'Update personal git repos to database'
   task :people, %i(force) => %i(environment) do |t, args|
      force = args[:force] =~ /true|force/

      ImportRepos.new(url: 'http://git.altlinux.org', path: '/people', scope: :person, depth: 3, force: force).do
   end
end
