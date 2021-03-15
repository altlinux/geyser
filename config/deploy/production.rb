# frozen_string_literal: true

set :repo_url, 'git@github.com:altlinux/geyser.git'

set :deploy_to, '/home/majioa/geyser'

set :rails_env, 'production'

server '176.113.80.84', user: 'majioa', roles: %w(app db web systemd)

set :ssh_options, port: 228

set :rvm_type, :user

set :app_server_host, "176.113.80.84"

set :nginx_domains, "176.113.80.84"

set :deploy_user, 'majioa'
set :nginx_sites_available_subfolder, "sites-available"
set :nginx_sites_enabled_subfolder, "sites-enabled"
