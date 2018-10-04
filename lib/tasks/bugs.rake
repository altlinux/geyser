# frozen_string_literal: true

namespace :sisyphus do
  desc 'Import all bugs to database'
  task bugs: %i(environment) do
    # TODO lock bug
    Rails.logger.info("#{ Time.zone.now }: import bugs")
    url = 'https://bugzilla.altlinux.org/buglist.cgi?ctype=csv'
    BugsImport.new(url).execute
    Rails.logger.info("#{ Time.zone.now }: end")
  end
end
