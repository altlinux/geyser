# frozen_string_literal: true

namespace :migrate do
  desc 'Call Branch.recount! on each branch'
  task recount: :environment do

    Branch.all.each do |branch|
      branch.recount!
    end

  end

  desc 'Add Source#source'
  task sources: :environment do
    Source.find_each do |source|
      if source.content?
        source.update!(source: true)
      else
        source.update!(source: false)
      end
    end
  end
end
