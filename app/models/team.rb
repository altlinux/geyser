# frozen_string_literal: true

class Team < ApplicationRecord
  belongs_to :branch

  belongs_to :maintainer

  validates :name, presence: true

  def self.import_teams(vendor_name, branch_name, url)
    branch = Branch.where(name: branch_name, vendor: vendor_name).first
    if branch.teams.count(:all) == 0
      file = open(URI.escape(url)).read
      file.each_line do |line|
        team_name = line.split[0]
        for i in 1..line.split.count-1
          maintainer = Maintainer.where(login: line.split[i]).first
          if maintainer.nil?
            puts "#{ Time.now }: maintainer not found '#{ line.split[i] }'"
          else
            if i == 1
              Team.create(name: team_name,
                          maintainer: maintainer,
                          leader: true,
                          branch: branch)
            else
              Team.create(name: team_name,
                          maintainer: maintainer,
                          leader: false,
                          branch: branch)
            end
          end
        end
      end
    else
      puts "#{ Time.now }: teams already imported"
    end
  end
end
