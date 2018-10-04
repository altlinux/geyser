# frozen_string_literal: true

namespace :sisyphus do
  desc 'Import repocop reports to database'
  task repocops: :environment do
    puts "#{ Time.zone.now }: import repocop reports"
    # TODO add lock
    Repocop.update_repocop
    Repocop.update_repocop_cache
    puts "#{ Time.zone.now }: end"
  end

  desc 'Update repocop status cache'
  task update_repocop_cache: :environment do
    puts "#{ Time.zone.now }: update repocop cache"
    # TODO add lock
    Repocop.update_repocop_cache
    puts "#{ Time.zone.now }: end"
  end

  desc 'Import repocop patches list to database'
  task repocop_patches: :environment do
    puts "#{ Time.zone.now }: import repocop patches"
    # TODO add lock
    RepocopPatch.update_repocop_patches
    puts "#{ Time.zone.now }: end"
  end
end
