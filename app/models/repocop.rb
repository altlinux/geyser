# frozen_string_literal: true

require 'open-uri'

class Repocop < ApplicationRecord
  belongs_to :branch

  validates :name, presence: true

  validates :version, presence: true

  validates :release, presence: true

  validates :arch, presence: true

  validates :srcname, presence: true

  validates :srcversion, presence: true

  validates :srcrel, presence: true

  validates :testname, presence: true

  class << self
    def update_repocop
      ActiveRecord::Base.transaction do
        Repocop.delete_all

        url = 'http://repocop.altlinux.org/pub/repocop/prometheus2/prometheus2.sql'
        file = open(URI.escape(url)).read

        file.each_line do |line|
          ActiveRecord::Base.connection.execute(line)
        end
      end
    end

    def update_repocop_cache
      branch = Branch.where(vendor: 'ALT Linux').first
      srpms = branch.srpms.all
      srpms.each do |srpm|
        repocops = Repocop.where(srcname: srpm.name,
                                 srcversion: srpm.version,
                                 srcrel: srpm.release).all

        repocop_status = 'skip'
        repocops.each do |repocop|
          if repocop.status == 'ok' && repocop_status != 'info' &&
             repocop_status != 'experimental' && repocop_status != 'warn' &&
             repocop_status != 'fail'
            repocop_status = 'ok'
          end
          if repocop.status == 'info' && repocop_status != 'experimental' &&
             repocop_status != 'warn' && repocop_status != 'fail'
            repocop_status = 'info'
          end
          if repocop.status == 'experimental' && repocop_status != 'warn' &&
             repocop_status != 'fail'
            repocop_status = 'experimental'
          end
          if repocop.status == 'warn' && repocop_status != 'fail'
            repocop_status = 'warn'
          end
          repocop_status = 'fail' if repocop.status == 'fail'
        end
        srpm.update_column(:repocop, repocop_status)
      end
    end
  end
end
