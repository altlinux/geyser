# frozen_string_literal: true

namespace :ftbfs do
  desc 'Import list of ftbfs packages on i586 and x86_64 to database'
  task update: :environment do
    require 'open-uri'

    puts "#{ Time.zone.now }: import ftbfs list for i586 and x86_64"
    # TODO add lock
    Ftbfs.transaction do
      Ftbfs.delete_all

      Ftbfs.update_ftbfs('ALT Linux', 'Sisyphus', 'http://git.altlinux.org/beehive/stats/Sisyphus-i586/ftbfs-joined', 'i586')
      Ftbfs.update_ftbfs('ALT Linux', 'Sisyphus', 'http://git.altlinux.org/beehive/stats/Sisyphus-x86_64/ftbfs-joined', 'x86_64')

      Ftbfs.update_ftbfs('ALT Linux', 'p7', 'http://git.altlinux.org/beehive/stats/p7-i586/ftbfs-joined', 'i586')
      Ftbfs.update_ftbfs('ALT Linux', 'p7', 'http://git.altlinux.org/beehive/stats/p7-x86_64/ftbfs-joined', 'x86_64')

      Ftbfs.update_ftbfs('ALT Linux', 'Platform6', 'http://git.altlinux.org/beehive/stats/p6-i586/ftbfs-joined', 'i586')
      Ftbfs.update_ftbfs('ALT Linux', 'Platform6', 'http://git.altlinux.org/beehive/stats/p6-x86_64/ftbfs-joined', 'x86_64')

      Ftbfs.update_ftbfs('ALT Linux', 't6', 'http://git.altlinux.org/beehive/stats/t6-i586/ftbfs-joined', 'i586')
      Ftbfs.update_ftbfs('ALT Linux', 't6', 'http://git.altlinux.org/beehive/stats/t6-x86_64/ftbfs-joined', 'x86_64')
    end
    puts "#{ Time.zone.now }: end"
  end
end
