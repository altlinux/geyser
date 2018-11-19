# frozen_string_literal: true

# job_type :rake, 'cd /home/prometheusapp/www/current && RAILS_ENV=:environment bundle exec rake :task :output'

# TODO: fix this
# every 1.day, at: '00:10' do
#   rake 'ts:index'
# end

every 1.hour do
   rake 'update:branches update:lost[true]'
end

every 3.hours, at: '0:35' do
   rake 'gear:update'
end

every 3.hours, at: '2:05' do
   rake 'bugs:update'
end

every 3.hours, at: '2:15' do
   rake 'ftbfs:update'
end

every 3.hours, at: '2:25' do
   rake 'watches:update'
end

every 1.day, at: '3:25' do # takes about 20 min
   rake 'repocop:update'
end

every :sunday, at: '03:30' do
#  rake 'sitemap:clean sitemap:refresh'
end

every :sunday, at: '06:30' do
#  rake 'perlwatch:update'
end

# every 5.minutes do
#   rake 'pghero:capture_query_stats'
# end

# Learn more: http://github.com/javan/whenever
