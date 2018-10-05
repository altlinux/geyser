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
    def login_exists?(login)
      Maintainer.where(login: login.downcase).count > 0
    end

    def import(maintainer)
      name = maintainer.split('<')[0].chomp
      name.strip!
      email = maintainer.chop.split('<')[1].split('>')[0]
      email.downcase!
      email = FixMaintainerEmail.new(email).execute
      login = email.split('@')[0]
      domain = email.split('@')[1]
      if domain == 'altlinux.org'
        unless login_exists?(login)
          Maintainer.create(login: login, name: name, email: email)
        end
      elsif domain == 'packages.altlinux.org'
        unless Maintainer::Team.team_exists?(login)
          Maintainer::Team.create!(login: login, name: name, email: email)
        end
      else
        raise 'Broken domain in Packager: tag'
      end
    end

    def import_from_changelogname(changelogname)
      pre_email = changelogname.chop.split('<')[1].split('>')[0].downcase
      email = FixMaintainerEmail.new(pre_email).execute

      Maintainer.find_or_create_by!(login: email.split('@')[0]) do |maintainer|
        maintainer.name = changelogname.split('<')[0].chomp.strip
        maintainer.email = email
      end
    end
  end
end
