class GearMaintainer < ApplicationRecord
  belongs_to :gear
  belongs_to :maintainer

  class << self
      def updated_at
         self.select("MAX(gear_maintainers.updated_at) AS updated_at").group(:id).first&.updated_at
      end
  end
end
