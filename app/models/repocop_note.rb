class RepocopNote < ApplicationRecord
   enum status: %i(skip ok experimental notice warning failure)

   WELL_STATUSES = self.statuses.keys[0..1]

   belongs_to :package, optional: true

   has_many :rpms, through: :package
   has_one :spkg, class_name: 'Package::Src', through: :package, source: :src
   has_one :srpm, class_name: 'Rpm', through: :spkg, source: :rpms

   scope :buggy, -> { where.not(status: WELL_STATUSES) }

   validates_presence_of :status, :kind, :description, :package_id

   delegate :fullname, :arch, to: :package, prefix: true
end
