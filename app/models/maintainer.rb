# frozen_string_literal: true

class Maintainer < ApplicationRecord
   has_one :email, -> { where(foremost: true) }, class_name: 'Recital::Email'

   has_many :packages, foreign_key: :builder_id, inverse_of: :builder
   has_many :rpms, through: :packages
   has_many :branch_paths, -> { distinct }, through: :rpms
   has_many :branches, -> { distinct }, through: :branch_paths
   has_many :branching_maintainers, dependent: :delete_all
   has_many :gear_maintainers
   has_many :gears, through: :gear_maintainers
   has_many :changelogs, -> { order(at: :desc) }
   has_many :issue_assignees
   has_many :ftbfs, class_name: 'Issue::Ftbfs', through: :issue_assignees, source: :issue
   has_many :bugs, class_name: 'Issue::Bug', through: :issue_assignees, source: :issue
   has_many :built_names, -> { src.select(:name).distinct }, through: :packages, source: :rpms
   has_many :acls, primary_key: 'login', foreign_key: 'maintainer_slug'
   has_many :acl_names, -> { select(:package_name).distinct },
                        primary_key: 'login',
                        foreign_key: 'maintainer_slug',
                        class_name: :Acl
   has_many :gear_names, -> { select(:reponame).distinct },
                        through: :gear_maintainers,
                        source: :gear,
                        class_name: :Gear
   has_many :emails, class_name: 'Recital::Email'

   scope :top, ->(limit) { order(srpms_count: :desc).limit(limit) }
   scope :person, -> { where("maintainers.login ~ '^[^@].*'", ) }
   scope :team, -> { where("maintainers.login ~ '^@.*'", ) }

   alias_method(:srpms_names, :built_names) #TODO remove of compat

   accepts_nested_attributes_for :email

   validates_presence_of :name

   def slug
      to_param
   end

   def has_supported?
      acl_names.present?
   end

   def has_login?
      login.present?
   end

   def support_count
      acl_names.count
   end

   def for_branch branch
      branching_maintainers.where(branch_id: branch).first
   end

   def locked_email
      email.gsub('@', ' аt ').gsub('.', ' dоt ')
   end

   def shown_name
      name || locked_email
   end

   def last_built_at
      changelogs.limit(1).first&.at
   end

   class << self
      def import_from_changelogname(changelogname)
         emails = changelogname&.scan(/[^<>@( ]+(?:@| at )[^<>@) ]+(?:\.| dot )[^<>@) ]+/)
         if emails.present?
            email = FixMaintainerEmail.new(emails.last).execute
         else
            email = 'somebody@somewhere.example'
         end

         (login, domain) = email.split('@')
         kls = (domain == 'packages.altlinux.org' && 'Maintainer::Team' || 'Maintainer::Person').constantize

         pre_name = (changelogname && changelogname.split('<')[0].chomp.strip).to_s
         name = if pre_name.blank?
            email
         elsif pre_name.encoding == "UTF-8"
            pre_name
         else
            if pre_name.ascii_only?
               pre_name.encode("UTF-8")
            else
               pre_name.force_encoding("ISO-8859-1").encode("UTF-8", replace: nil)
            end
         end

         Recital::Email.find_or_create_by!(address: email) do |re|
            re.maintainer = Maintainer.new(name: name, login: /@(packages\.)?altlinux\.org$/ =~ email && login || nil)
         end.maintainer
      end
   end
end
