# frozen_string_literal: true

set :repo_url, 'git@github.com:altlinux/geyser.git'


set :deploy_to, '/var/www/geyser'

set :rails_env, 'staging'

set :branch, ENV['BRANCH'] || "staging"

server 'predvridlo.office.basealt.ru', user: 'apache', roles: %w(app db web systemd)

set :ssh_options, port: 22

set :rvm_type, :user

set :app_server_host, "predvridlo.office.basealt.ru"

set :nginx_domains, "predvridlo.office.basealt.ru"
