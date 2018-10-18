# frozen_string_literal: true

require 'open-uri'

class Gear < ApplicationRecord
   has_many :spkgs, primary_key: :reponame, foreign_key: :name, class_name: 'Package::Src'

   validates_presence_of :reponame, :url, :changed_at
end
