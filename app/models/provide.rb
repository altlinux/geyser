class Provide < ApplicationRecord
  belongs_to :package

  validates :name, presence: true

# FIXME: this code is broken
#  def self.import_provides(rpm, package)
#    rpm.provides.each do |p|
#      provide = Provide.new
#      provide.package = package
#      provide.name = p.name
#      provide.version = p.version.v
#      provide.release = p.version.r
#      provide.epoch = p.version.e
#      provide.flags = p.flags
#      provide.save!
#    end
#  end
end
