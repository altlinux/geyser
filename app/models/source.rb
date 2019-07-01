# frozen_string_literal: true

class Source < ApplicationRecord
   belongs_to :package, class_name: 'Package::Src'

   scope :for_packages, ->(packages) { where(package_id: packages) }
   scope :uniq_by, ->(name) { select("DISTINCT ON(sources.#{name}) sources.*") }
   scope :real, -> { where.not(size: 0) }

   validates_presence_of :filename, :size

   def self.prep_attrs rpm, package
      files = `rpm -q --qf '[%{BASENAMES}\t%{FILESIZES}\n]' -p #{ rpm.file }`
      hsh = {}
      files.split("\n").each do |line|
         hsh[line.split("\t")[0]] = line.split("\t")[1]
      end
      sources = `rpm -q --qf '[%{SOURCE}\n]' -p #{ rpm.file }`
      sources.split("\n").map do |filename|
         {
            source: false,
            size: hsh[filename].to_i,
            filename: filename,
            package_id: package.id,
         }
      end
   end

   def self.import_from rpm, package
      self.import!(prep_attrs(rpm, package))
   end

   def to_param
      filename
   end
end
