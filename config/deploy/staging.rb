# frozen_string_literal: true

set :repo_url, 'git@github.com:altlinux/geyser.git'


set :deploy_to, '/var/www/geyser'

set :rails_env, 'staging'

set :branch, ENV['BRANCH'] || "staging"

server '10.10.3.49', user: 'apache', roles: ['app', 'db', 'web']

set :ssh_options, port: 22

set :rvm_type, :user

set :app_server_host, "staging.office.basealt.ru"

set :nginx_domains, "staging.office.basealt.ru"
