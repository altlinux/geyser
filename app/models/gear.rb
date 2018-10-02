# frozen_string_literal: true

require 'open-uri'

class Gear < ApplicationRecord
  belongs_to :maintainer

  has_many :spkgs, primary_key: :repo, foreign_key: :name, class_name: 'Package::Src'

  validates_presence_of :repo, :lastchange

  def self.update_gitrepos(url)
    ActiveRecord::Base.transaction do
      Gear.delete_all
      Gear.import_gitrepos(url)
    end
  end

  def self.import_gitrepos(url)
    branch = Branch.where(slug: 'sisyphus').first
    file = open(URI.escape(url)).read
    file.each_line do |line|
      gitrepo = line.split[0]
      login = gitrepo.split('/')[2]
      login = 'php-coder' if login == 'php_coder'
      login = 'p_solntsev' if login == 'psolntsev'
      package = gitrepo.split('/')[4]
      time = Time.at(line.split[1].to_i)

      maintainer = Maintainer.where(login: login).first
      name = package.gsub(/\.git/, '')

      # puts "#{ Time.now }: maintainer not found '#{ login }'" unless maintainer
      # puts "#{ Time.now }: srpm not found '#{ package.gsub(/\.git/, '') }'" unless srpm

      if maintainer && name
        Gear.create!(
          repo: name,
          maintainer_id: maintainer.id,
          lastchange: time,
        )
      end
    end
  end
end
