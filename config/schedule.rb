# frozen_string_literal: true

every 3.hours, at: '2:35 am', roles: [:rake] do
   rake 'repo:gears repo:srpms repo:people'
end

every 3.hours, at: '2:05 am', roles: [:rake] do
   rake 'bugs:update'
end

every 3.hours, at: '2:15 am', roles: [:rake] do
   rake 'ftbfs:update'
end

every 3.hours, at: '2:25 am', roles: [:rake] do
   rake 'novelties:update'
end

every 1.day, at: '3:00 am', roles: [:rake] do
   rake 'update:branches update:lost[true] update:upcache'
end

every 1.day, at: '1:00 am', roles: [:rake] do
   rake 'task:update'
end

every 1.day, at: '3:25 am', roles: [:rake] do # takes about 20 min
   rake 'repocop:update'
end

every 1.day, at: '3:45 am', roles: [:rake] do # takes about 5 min
   rake 'fix:branching_maintainers'
end

every :sunday, at: '03:30 am', roles: [:web] do
  rake 'sitemap:clean sitemap:refresh'
end

every :sunday, at: '06:30 am', roles: [:rake] do
#  rake 'perlwatch:update'
end

# every 5.minutes do
#   rake 'pghero:capture_query_stats'
# end

# Learn more: http://github.com/javan/whenever
