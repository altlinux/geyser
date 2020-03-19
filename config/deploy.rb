# frozen_string_literal: true

lock '3.12.1'

set :application, 'geyser'
set :deploy_user, 'apache'

set :branch, ENV['BRANCH'] || "master"
set :bundle_flags, '--quiet'

# Defaults to false
# Skip migration if files in db/migrate were not modified
set :conditionally_migrate, true

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, 'config/secrets.yml',
                      'config/newrelic.yml',
                      'config/database.yml',
                      '.env'

# Default value for linked_dirs is []
append :linked_dirs, 'log',
                     'tmp/pids',
                     'tmp/cache',
                     'tmp/sockets',
                     'public/system'

# Default value for keep_releases is 5
set :keep_releases, 3

set :bundle_jobs, 4
set :bundle_binstubs, -> { shared_path.join('bin') }

set :nginx_path, '/etc/nginx' # directory containing sites-available and sites-enabled
set :nginx_template, 'config/nginx.conf.erb' # configuration template
set :nginx_sites_available_subfolder, "sites-available.d"
set :nginx_sites_enabled_subfolder, "sites-enabled.d"
set :nginx_listen, 80 # optional, default is not set
set :nginx_roles, :all

#set :nginx_service_path, "/etc/init.d/nginx"
#set :nginx_sites_available_dir, "/etc/nginx/sites-available.d"
#set :nginx_sites_enabled_dir, "/etc/nginx/sites-enabled.d"
#set :nginx_application_name, "#{fetch :application}-#{fetch :stage}.conf"
#set :nginx_template, "config/nginx.conf.erb"
set :app_server_socket, "#{shared_path}/sockets/puma-#{fetch :application}.sock"
set :app_server_host, "localhost"
set :app_server_port, 80

# set :rvm_type, :user                      # Defaults to: :auto
# set :rvm_ruby_version, 'ext-ruby-2.5.1'    # Defaults to: 'default'
# set :rvm_custom_path, '~/.rvm'          # only needed if not detected
set :rvm_roles, %i[app web]

set :puma_conf, "#{release_path}/config/puma.rb"

# Default settings
set :foreman_use_sudo, true # Set to :rbenv for rbenv sudo, :rvm for rvmsudo or true for normal sudo
set :foreman_roles, :all
set :foreman_init_system, 'systemd'
set :foreman_export_path, ->{ '/etc/systemd/system/' }
set :foreman_app, -> { 'geyser' }
set :foreman_app_name_systemd, -> { "#{ fetch(:foreman_app) }.target" }
set :foreman_options, ->{ {
  app: fetch(:foreman_app),
  user: fetch(:deploy_user),
  log: File.join(shared_path, 'log')
} }


namespace :deploy do
  after :finishing, 'deploy:cleanup'
  after 'deploy:finishing', 'foreman:restart'
  before 'foreman:restart', 'foreman:export'
  after 'foreman:restart', 'nginx:setup'
  after 'nginx:setup', 'nginx:enable_site'
end
