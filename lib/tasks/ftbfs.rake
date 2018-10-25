# frozen_string_literal: true

namespace :ftbfs do
  desc 'Import list of ftbfs packages on i586 and x86_64 to database'
  task update: :environment do
     ImportFtbfses.new.do
  end
end
