# frozen_string_literal: true

ruby '2.7.1'

source 'https://rubygems.org'

gem 'rails', '~> 5.2.4.4'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.12', '>= 3.12.6'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'bootsnap', '>= 1.1.0', require: false

gem 'rack-health'
gem 'rails-i18n'
gem 'kaminari'
gem 'kaminari-i18n'
gem 'rack-mini-profiler', require: false
gem 'pghero'
gem 'pg_query'
# gem 'maily'
gem 'pg_search'
gem 'devise'
gem 'draper'
gem 'fast_gettext'
gem 'gettext_i18n_rails'
gem 'gettext', require: false
gem 'whenever', require: false
gem 'awesome_nested_set'
gem 'sitemap_generator'
gem 'rouge'
# gem 'github-linguist'
gem 'swagger-blocks'
gem 'rack-cors', require: 'rack/cors'
# gem 'oink'
gem 'rectify'
gem 'posix-spawn', require: false
gem 'terrapin', require: false
gem 'browser'
gem 'http_accept_language'
# gem 'molinillo', require: false
#
# model
gem 'activerecord-import', '~> 1.0'

# view
gem 'slim'

# controller
gem 'has_scope'

# seed
gem 'factory_bot_rails'

# serialization
gem 'active_model_serializers'

# git
gem 'git', require: false, git: "https://github.com/majioa/ruby-git.git"

# caching
gem 'dalli'

# environment
gem 'bundler', '~> 2.0'
gem 'dotenv-rails'

# worker
gem 'delayed_job_active_record'

# http/ftp
gem 'excon'

# assets
gem 'webpacker'

group :production, :staging do
  gem 'lograge'
  gem 'rack-timeout', require: false
  gem 'rack-force_domain'
  gem 'exception_notification'
  gem 'puma_worker_killer'
  gem 'foreman', '~> 0.85'
end

group :staging, :development, :test do
  gem 'pry-rails'
  gem 'pry-remote', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'spring-commands-rubocop'

  gem 'bullet'

  # See https://github.com/net-ssh/net-ssh/issues/565 for more information
  gem 'ed25519', '>= 1.2', '< 2.0', require: false
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0', require: false

  gem 'capistrano', '~> 3.6', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-faster-assets', require: false
  gem 'capistrano-nginx', github: "majioa/capistrano-nginx", require: false
  gem 'capistrano-foreman', '~> 1.4.0'
  # gem 'capistrano3-puma', github: "seuros/capistrano-puma", require: false
  gem 'capistrano-rake'
  # gem 'xray-rails'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-thread_safety', require: false
  gem 'mry', require: false
  gem 'brakeman', require: false
  # gem 'lol_dba'
  gem 'squasher', require: false
  # gem 'bundler-audit', require: false
  # gem 'bundler-stats', require: false
  gem 'license_finder', require: false
  gem 'active_record_doctor'
  gem 'http_logger'
  gem 'cacheflow'

  gem 'ruby_parser'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'awesome_print'
  gem 'faker'
end

group :test do
  gem 'rspec-its'
  gem 'rspec-activemodel-mocks'
  gem 'shoulda-matchers', '~> 4.0.0.rc1'
  gem 'shoulda-callback-matchers'
  gem 'rails-controller-testing'
  gem 'rspec-matchers-controller_filters'
  gem 'capybara'
  gem 'capybara-email'
  gem 'launchy'
  gem 'database_rewinder'
  gem 'webmock', require: false
  gem 'simplecov', require: false
  gem 'codeclimate-test-reporter'
end
