# frozen_string_literal: true

class RepocopPatch < ApplicationRecord
   belongs_to :package, class_name: 'Package::Src'

   validates_presence_of :text

   def filename
      "#{package.fullname}.patch"
   end
end
