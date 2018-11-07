# frozen_string_literal: true

require 'open-uri'

class Gear < ApplicationRecord
   has_many :spkgs, primary_key: :reponame, foreign_key: :name, class_name: 'Package::Src'
   has_many :gear_maintainers

   scope :for_maintainer, ->(maintainer) { where(gear_maintainers: { maintainer_id: maintainer }) }
   scope :maintainly_unanalyzed, -> do
      updated_at = GearMaintainer.updated_at || Time.at(0)

      ids = Gear.joins(:gear_maintainers).where("gear_maintainers.updated_at IS NOT NULL").distinct.select(:id)

      self.where("gears.changed_at >= ?", updated_at).or(self.where.not(id: ids)).order(:reponame)
   end

   validates_presence_of :reponame, :url, :changed_at

   def path_for prefix
      "#{prefix}/#{kind.pluralize}/#{reponame[0]}/#{reponame}.git"
   end
end
