# frozen_string_literal: true

namespace :sisyphus do
  desc 'Update Sisyphus stuff'
  task update: :environment do
    puts "#{ Time.zone.now }: Update Sisyphus stuff"
    if Redis.current.get('__SYNC__')
      exist = begin
                Process.kill(0, Redis.current.get('__SYNC__').to_i)
                true
              rescue
                false
              end
      if exist
        puts "#{ Time.zone.now }: update is locked by another cron script"
        Process.exit!(true)
      else
        puts "#{ Time.zone.now }: dead lock found and deleted"
        Redis.current.del('__SYNC__')
      end
    end
    Redis.current.set('__SYNC__', Process.pid)
    puts "#{ Time.zone.now }: update *.src.rpm from Sisyphus to database"
    branch = Branch.find_by!(name: 'Sisyphus')
    Srpm.import_all(branch, '/ALT/Sisyphus/files/SRPMS/*.src.rpm')
    # Srpm.import_all(branch, '/Users/biow0lf/Sisyphus/files/SRPMS/*.src.rpm')
    RemoveOldSrpms.call(branch, '/ALT/Sisyphus/files/SRPMS/') do
      on(:ok) { puts "#{ Time.zone.now }: Old srpms removed" }
    end
    # RemoveOldSrpms.call(branch, '/Users/biow0lf/Sisyphus/files/SRPMS/') do
    #   on(:ok) { puts "#{ Time.now }: Old srpms removed" }
    # end
    puts "#{ Time.zone.now }: update *.i586.rpm/*.noarch.rpm/*.x86_64.rpm from Sisyphus to database"
    pathes = ['/ALT/Sisyphus/files/i586/RPMS/*.i586.rpm',
              '/ALT/Sisyphus/files/noarch/RPMS/*.noarch.rpm',
              '/ALT/Sisyphus/files/x86_64/RPMS/*.x86_64.rpm']
    # pathes = ['/Users/biow0lf/Sisyphus/files/i586/RPMS/*.i586.rpm',
    #           '/Users/biow0lf/Sisyphus/files/noarch/RPMS/*.noarch.rpm',
    #           '/Users/biow0lf/Sisyphus/files/x86_64/RPMS/*.x86_64.rpm']
    Package.import_all(branch, pathes)
    puts "#{ Time.zone.now }: end"
    puts "#{ Time.zone.now }: update acls in redis cache"
    Acl.update_redis_cache(branch, 'http://git.altlinux.org/acl/list.packages.sisyphus')
    puts "#{ Time.zone.now }: end"
    puts "#{ Time.zone.now }: update leaders in redis cache"
    Leader.update_redis_cache(branch, 'http://git.altlinux.org/acl/list.packages.sisyphus')
    puts "#{ Time.zone.now }: end"
    puts "#{ Time.zone.now }: update time"
    Redis.current.set("#{ branch.name }:updated_at", Time.now.to_s)
    puts "#{ Time.zone.now }: end"
    Redis.current.del('__SYNC__')
  end

  # desc 'Import all leaders for packages from Sisyphus to database'
  # task leaders: :environment do
  #   require 'open-uri'
  #   puts "#{ Time.now }: import all leaders for packages from Sisyphus to database"
  #   Leader.import_leaders('ALT Linux', 'Sisyphus', 'http://git.altlinux.org/acl/list.packages.sisyphus')
  #   puts "#{ Time.now }: end"
  # end
  #
  # desc 'Import all teams from Sisyphus to database'
  # task teams: :environment do
  #   require 'open-uri'
  #   puts "#{ Time.now }: import all teams from Sisyphus to database"
  #   Team.import_teams('ALT Linux', 'Sisyphus', 'http://git.altlinux.org/acl/list.groups.sisyphus')
  #   puts "#{ Time.now }: end"
  # end
end
