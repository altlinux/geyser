# frozen_string_literal: true

class Patch < ApplicationRecord
   belongs_to :package, class_name: 'Package::Src'

   scope :for_packages, ->(packages) { where(package_id: packages) }
   scope :uniq_by, ->(name) { select("DISTINCT ON(patches.#{name}) patches.*") }
   scope :presented, -> { where.not(patch: "") }

   validates_presence_of :filename, :size

  def self.import rpm, package
    files = `rpm -q --qf '[%{BASENAMES}\t%{FILESIZES}\n]' -p #{ rpm.file }`
    hsh = {}
    files.split("\n").each do |line|
      hsh[line.split("\t")[0]] = line.split("\t")[1]
    end
    patches = `rpm -q --qf '[%{PATCH}\n]' -p #{ rpm.file }`
    patches.split("\n").each do |filename|
      patch = Patch.new

      # DON'T import patch if size is more than 512k
      if hsh[filename].to_i <= 1024 * 512
        content = `rpm2cpio "#{ rpm.file }" | cpio -i --quiet --to-stdout "#{ filename }"`
        patch.patch = content.force_encoding('BINARY')
      end

      patch.size = hsh[filename].to_i
      patch.filename = filename
      patch.package_id = package.id
      patch.save!
    end
  end

  def to_param
    filename
  end
end
