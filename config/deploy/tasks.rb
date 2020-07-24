# frozen_string_literal: true

host = ENV['HOST'] || 'dnisce.office.basealt.ru'

set :repo_url, 'git@github.com:altlinux/geyser.git'

set :deploy_to, '/var/www/geyser'

set :rails_env, 'production'

server host, user: 'apache', roles: %w(rake)

set :ssh_options, port: 22

set :rvm_type, :user
# set :rvm_custom_path, '~/.rvm'          # only needed if not detected

set :app_server_host, host
