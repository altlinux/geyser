class RepocopNote < ApplicationRecord
   enum status: %i(skip ok experimental notice warning failure)

   WELL_STATUSES = self.statuses.keys[0..1]

   belongs_to :package, class_name: 'Package::Built', optional: true

   scope :buggy, -> { where.not(status: WELL_STATUSES) }

   validates_presence_of :status, :kind, :description, :package_id

   delegate :fullname, :arch, to: :package, prefix: true
end
