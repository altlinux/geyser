# frozen_string_literal: true

class Package::Src < Package
   has_one :repocop_patch, primary_key: 'name', foreign_key: 'name', dependent: :destroy
   has_one :specfile, foreign_key: :package_id, inverse_of: :package, dependent: :destroy
   has_one :changelog, foreign_key: :spkg_id, inverse_of: :spkg, dependent: :destroy
   has_one :gear, -> { where(kind: 'gear').order(changed_at: :DESC) },
                        primary_key: :name,
                        foreign_key: :reponame

   has_one :srpm_git, -> { where(kind: 'srpm').order(changed_at: :DESC) },
                        primary_key: :name,
                        foreign_key: :reponame,
                        class_name: :Gear

   has_many :packages, foreign_key: :src_id, class_name: 'Package::Built', dependent: :destroy
   has_many :built_rpms, through: :packages, source: :rpms, class_name: 'Rpm'
   has_many :changelogs, foreign_key: :package_id, inverse_of: :package, dependent: :destroy
   has_many :patches, foreign_key: :package_id, inverse_of: :package, dependent: :destroy
   has_many :sources, foreign_key: :package_id, inverse_of: :package, dependent: :destroy
   has_many :repocops, -> { order(name: :asc) },
                       primary_key: :name,
                       foreign_key: :srcname,
                       dependent: :destroy
   has_many :gears, -> { order(changed_at: :desc) }, primary_key: :name, foreign_key: :reponame

   has_many :acls, primary_key: :name, foreign_key: :package_name
   has_many :contributors, ->{ distinct.order(:name) }, through: :changelogs, source: :maintainer, class_name: :Maintainer

   scope :top_rebuilds_after, ->(date) do
      where("packages.buildtime > ?", date)
         .select(:name, 'count(packages.name) as id')
         .group(:name)
         .having('count(packages.name) > 5')
         .order('id DESC', :name)
   end

   def last_changelog_text
      changelog&.text
   end
end
