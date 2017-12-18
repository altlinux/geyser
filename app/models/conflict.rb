# frozen_string_literal: true

class Conflict < ApplicationRecord
  belongs_to :package

  validates :name, presence: true

# FIXME: this code broken
#  def self.import_conflicts(rpm, package)
#    rpm.conflicts.each do |c|
#      conflict = Conflict.new
#      conflict.package = package
#      conflict.name = c.name
#      conflict.version = c.version.v
#      conflict.release = c.version.r
#      conflict.epoch = c.version.e
#      conflict.flags = c.flags
#      conflict.save!
#    end
#  end
end
