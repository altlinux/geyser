# frozen_string_literal: true

class Gear < ApplicationRecord
   has_many :spkgs, primary_key: :reponame, foreign_key: :name, class_name: 'Package::Src'
   has_many :gear_maintainers
   has_many :maintainers, through: :gear_maintainers
   has_many :srpms, through: :spkgs, class_name: 'Rpm', source: :rpms
   has_many :branch_paths, -> { distinct }, through: :srpms, source: :branch_path
   has_many :branches, -> { distinct }, through: :branch_paths, source: :branch

   scope :pure, -> { where(kind: %w(srpms gears)) }
   scope :for_spkg, ->(spkg) { joins(:spkgs).where(packages: { id: spkg.id }).distinct }
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
