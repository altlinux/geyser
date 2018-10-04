# frozen_string_literal: true

namespace :gear do
  desc 'Import all git repos to database'
  task import: :environment do
    puts "#{ Time.zone.now }: import gitrepos"
    #TODO add lock
    Gear.transaction do
      Gear.import_gitrepos('http://git.altlinux.org/people-packages-list')
    end
    puts "#{ Time.zone.now }: end"
  end

  desc 'Update all git repos to database'
  task update: :environment do
    puts "#{ Time.zone.now }: update gitrepos"
    #TODO add lock
    Gear.transaction do
      Gear.update_gitrepos('http://git.altlinux.org/people-packages-list')
    end
    puts "#{ Time.zone.now }: end"
  end
end
