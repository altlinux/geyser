# frozen_string_literal: true

class Require < ApplicationRecord
  belongs_to :package

  validates :name, presence: true

# FIXME: this code is broken
#  def self.import_requires(rpm, package)
#    rpm.requires.each do |r|
#      req = Require.new
#      req.package = package
#      req.name = r.name
#      req.version = r.version.v
#      req.release = r.version.r
#      req.epoch = r.version.e
#      req.flags = r.flags
#      req.save!
#    end
#  end
end
