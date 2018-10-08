# frozen_string_literal: true

class Maintainer < ApplicationRecord
   validates :name, presence: true

   validates :email, presence: true

   validates :login, presence: true, uniqueness: true

   validates :name, immutable: true

   validates :email, immutable: true

   validates :login, immutable: true

   has_many :packages, foreign_key: :builder_id, inverse_of: :builder
   has_many :rpms, through: :packages
   has_many :branch_paths, -> { distinct }, through: :rpms
   has_many :branches, -> { distinct }, through: :branch_paths
   has_many :branching_maintainers, dependent: :delete_all
   has_many :gears
   has_many :ftbfs, class_name: 'Ftbfs'
   has_many :built_names, -> { src.select(:name).distinct }, through: :packages, source: :rpms
   has_many :acls, primary_key: 'login', foreign_key: 'maintainer_slug'
   has_many :acl_names, -> { select(:package_name).distinct },
                        primary_key: 'login',
                        foreign_key: 'maintainer_slug',
                        class_name: :Acl

   scope :top, ->(limit) { order(srpms_count: :desc).limit(limit) }
   scope :person, -> { where("maintainers.login !~ '^@.*'", ) }
   scope :team, -> { where("maintainers.login ~ '^@.*'", ) }

   alias_method(:srpms_names, :built_names) #TODO remove of compat

   def slug
      to_param
   end

   def has_supported?
      acl_names.present?
   end

   def support_count
      acl_names.count
   end

   class << self
      def import_from_changelogname(changelogname)
         email = FixMaintainerEmail.new(changelogname.chop.split('<')[1].split('>')[0].downcase).execute
         (login, domain) = email.split('@')
         kls = (domain == 'packages.altlinux.org' && 'Maintainer::Team' || 'Maintainer::Person').constantize
         name = changelogname.split('<')[0].chomp.strip

         kls.find_or_create_by!(email: email) do |m|
            m.name = name
            m.login = login
         end
      end
   end
end
