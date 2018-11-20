# frozen_string_literal: true

namespace :novelties do
   desc 'Import list of new packages from various external sources to database to make them as a task for new internal package'
   task update: :environment do
      ImportNovelties.new(url: "https://watch.altlinux.org/pub/watch/by-leader/").do
   end
end
