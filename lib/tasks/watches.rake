# frozen_string_literal: true

namespace :watches do
  desc 'Import list of new packages from various external sources to database to make them as a task for new internal package'
  task update: :environment do
     ImportWatches.new(url: "https://watch.altlinux.org/pub/watch/by-leader/").do
  end
end
