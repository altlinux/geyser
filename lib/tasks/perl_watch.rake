# frozen_string_literal: true

namespace :perlwatch do
  desc 'Import CPAN info to database'
  task update: :environment do
    puts "#{ Time.zone.now }: import CPAN info to database"
    # TODO add lock
    PerlWatch.import_data('http://www.cpan.org/modules/02packages.details.txt.gz')
    puts "#{ Time.zone.now }: end"
  end
end
