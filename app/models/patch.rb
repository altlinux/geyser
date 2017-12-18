# frozen_string_literal: true

class Patch < ApplicationRecord
  belongs_to :srpm

  validates :filename, presence: true

  validates :size, presence: true

  def self.import(file, srpm)
    files = `rpm -q --qf '[%{BASENAMES}\t%{FILESIZES}\n]' -p #{ file }`
    hsh = {}
    files.split("\n").each do |line|
      hsh[line.split("\t")[0]] = line.split("\t")[1]
    end
    patches = `rpm -q --qf '[%{PATCH}\n]' -p #{ file }`
    patches.split("\n").each do |filename|
      patch = Patch.new

      # DON'T import patch if size is more than 512k
      if hsh[filename].to_i <= 1024 * 512
        content = `rpm2cpio "#{ file }" | cpio -i --quiet --to-stdout "#{ filename }"`
        patch.patch = content.force_encoding('BINARY')
      end

      patch.size = hsh[filename].to_i
      patch.filename = filename
      patch.srpm_id = srpm.id
      patch.save!
    end
  end

  def to_param
    filename
  end
end
