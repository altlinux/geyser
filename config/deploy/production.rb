# frozen_string_literal: true

set :repo_url, 'git@github.com:majioa/prometheus2.0.git'

set :deploy_to, '/var/www/prometheus2.0'

set :rails_env, 'production'

server 'packages.altlinux.org', user: 'apache', roles: ['app', 'db', 'web']

set :ssh_options, port: 222

set :rvm_type, :user

set :app_server_host, "packages.altlinux.org"

set :nginx_domains, "packages.altlinux.org"
