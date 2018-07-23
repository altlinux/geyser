# frozen_string_literal: true

# job_type :rake, 'cd /home/prometheusapp/www/current && RAILS_ENV=:environment bundle exec rake :task :output'

# TODO: fix this
# every 1.day, at: '00:10' do
#   rake 'ts:index'
# end

every '5 1-23 * * *' do
  rake 'sisyphus:update p8:update p7:update t7:update p6:update t6:update p5:update 51:update 50:update 41:update 40:update gear:update update:sisyphus:aarch64'
end

# every 1.day, at: '05:30' do
#   rake 'sisyphusarm:update'
# end

every 1.day, at: '05:00' do
  rake 'sisyphus:bugs'
end

every 1.day, at: '06:45' do
  rake 'sisyphus:repocops sisyphus:repocop_patches'
end

every 1.day, at: '12:50' do
  rake 'ftbfs:update'
end

every :sunday, at: '03:30' do
  rake 'sitemap:clean sitemap:refresh'
end

every :sunday, at: '06:30' do
  rake 'perlwatch:update'
end

# every 5.minutes do
#   rake 'pghero:capture_query_stats'
# end

# Learn more: http://github.com/javan/whenever
