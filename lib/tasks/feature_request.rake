# frozen_string_literal: true

namespace :feature_request do
  desc 'Import list of new packages from variaous sources to database'
  task update: :environment do
     ImportFeatureRequests.new(url: "https://watch.altlinux.org/pub/watch/by-leader/").do
  end
end
