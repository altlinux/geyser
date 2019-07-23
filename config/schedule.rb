# frozen_string_literal: true

every 3.hours, at: '2:35 am' do
   rake 'repo:gears repo:srpms repo:people'
end

every 3.hours, at: '2:05 am' do
   rake 'bugs:update'
end

every 3.hours, at: '2:15 am' do
   rake 'ftbfs:update'
end

every 3.hours, at: '2:25 am' do
   rake 'novelties:update'
end

every 1.day, at: '3:00 am' do
   rake 'update:branches update:lost[true] update:upcache'
end

every 1.day, at: '1:00 am' do
   rake 'task:update'
end

every 1.day, at: '3:25 am' do # takes about 20 min
   rake 'repocop:update'
end

every 1.day, at: '3:45 am' do # takes about 5 min
   rake 'fix:branching_maintainers'
end

every :sunday, at: '03:30 am' do
  rake 'sitemap:clean sitemap:refresh'
end

every :sunday, at: '06:30 am' do
#  rake 'perlwatch:update'
end

# every 5.minutes do
#   rake 'pghero:capture_query_stats'
# end

# Learn more: http://github.com/javan/whenever
