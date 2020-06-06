# frozen_string_literal: true

lock '3.13.0'

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
set :nginx_roles, %i(web)

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
set :rvm_roles, %i[app web rake]

set :puma_conf, "#{release_path}/config/puma.rb"

# Default settings
set :foreman_use_sudo, true # Set to :rbenv for rbenv sudo, :rvm for rvmsudo or true for normal sudo
set :foreman_roles, %i[systemd]
set :foreman_init_system, 'systemd'
set :foreman_export_path, ->{ '/etc/systemd/system/' }
set :foreman_app, -> { 'geyser' }
set :foreman_app_name_systemd, -> { "#{ fetch(:foreman_app) }.target" }
set :foreman_options, ->{ {
  app: fetch(:foreman_app),
  user: fetch(:deploy_user),
  log: File.join(shared_path, 'log')
} }

set :whenever_roles, %i[web rake]

namespace :deploy do
  before 'deploy:check:linked_files', 'deploy:check:shared'
  before 'deploy:check:linked_files', 'deploy:check:mounts'
  after :finishing, 'deploy:cleanup'
  after 'deploy:finishing', 'foreman:restart'
  before 'foreman:restart', 'foreman:export'
  after 'foreman:restart', 'nginx:setup'
  after 'nginx:setup', 'nginx:enable_site'
  before "deploy:cleanup", "deploy:reload"
end


namespace :deploy do
  task :reload do
    on roles(:sysvinit) do
      execute :sudo, "killall -9 ruby || true"
      execute :sudo, "/usr/sbin/geyser || true"
    end
  end

  namespace :check do
    task :shared do
      on roles(:all) do
        execute "mkdir -p $HOME/geyser/shared/config"
        execute "touch $HOME/geyser/shared/config/secrets.yml"
        execute "touch $HOME/geyser/shared/config/database.yml"
        execute "touch $HOME/geyser/shared/config/newrelic.yml"
        execute "touch $HOME/geyser/shared/.env"
      end
    end
  end

  namespace :check do
    task :mounts do
      on roles(:systemd, :rake) do
        execute :sudo, "mkdir -p /beehive/ /archive_git/ /people/ /ports/ /roland/ /tasks /gears /home/nosrpm/e2k/ /srpms /archive || true"
        execute :sudo, "chmod 777 /archive_git/ /people/ /beehive/ /ports/ /roland/ /tasks /gears /home/nosrpm/e2k/ /srpms /archive || true"

        execute "sshfs -p 222 apache@packages.altlinux.org:/srpms/ /srpms || true"
        execute "sshfs -p 222 apache@packages.altlinux.org:/gears/ /gears || true"
        execute "sshfs -p 222 apache@packages.altlinux.org:/people/ /people/ || true"

        execute "sshfs -p 222 apache@packages.altlinux.org:/beehive/ /beehive/ || true"
        execute "sshfs -p 222 apache@packages.altlinux.org:/roland/ /roland/ || true"
        execute "sshfs -p 222 apache@packages.altlinux.org:/ports/ /ports/ || true"
        execute "sshfs -p 222 apache@packages.altlinux.org:/tasks/ /tasks || true"
        execute "sshfs -p 222 apache@packages.altlinux.org:/archive/ /archive || true"

        execute "sshfs -p 222 apache@packages.altlinux.org:/home/nosrpm/e2k/ /home/nosrpm/e2k/ || true"
      end
    end
  end
end
