# frozen_string_literal: true

class Maintainer < ApplicationRecord
   has_one :email, -> { where(foremost: true) }, class_name: 'Recital::Email'

   has_many :packages, foreign_key: :builder_id, inverse_of: :builder
   has_many :rpms, through: :packages, source: :rpms
   has_many :branch_paths, -> { distinct }, through: :rpms
   has_many :branches, -> { distinct }, through: :branch_paths
   has_many :branching_maintainers, dependent: :delete_all
   has_many :gears, -> { order(changed_at: :desc) }, primary_key: :login, foreign_key: :holder_slug, class_name: "Repo"
   has_many :tags, foreign_key: :author_id
   has_many :tagged_tags, foreign_key: :tagger_id, class_name: "Tag"
   has_many :repo_tags, -> { distinct }, through: :tags
   has_many :tagged_repo_tags, -> { distinct }, through: :tagged_tags, source: :tagger, class_name: "RepoTag"
   has_many :repos, -> { distinct }, through: :repo_tags
   has_many :tagged_repos, -> { distinct }, through: :tagged_repo_tags, source: :repo, class_name: "Repo"
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
   has_many :gear_names, -> { select(:name).distinct }, source: :gears, primary_key: :login, foreign_key: :holder_slug, class_name: :Repo
   has_many :emails, class_name: 'Recital::Email'
   has_many :spkgs, -> { distinct }, through: :repos, class_name: 'Package', source: :spkgs
   has_many :repocop_notes, -> { distinct }, through: :spkgs
   has_many :tasks, -> { order(changed_at: :desc).distinct }, primary_key: :login, foreign_key: :owner_slug

   scope :top, ->(limit) { order(srpms_count: :desc).limit(limit) }
   scope :person, -> { where("maintainers.login ~ '^[^@].*'") }
   scope :team, -> { where("maintainers.login ~ '^@.*'") }
   scope :with_login, ->(login) { where("maintainers.login ~ '^@\??'", login) }
   scope :with_email, ->(email) { joins(:email).where({ recitals: { address: email }}) }

   alias_method(:srpms_names, :built_names) #TODO remove of compat

   validates_presence_of :name, :email

   def affected_repo_names
     Repo.left_outer_joins(:tags)
         .where(holder_slug: self.login)
         .or(Repo.where(tags: {author_id: self.id}))
         .select(:name)
         .distinct
   end

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
      def parse_changelogname changelogname
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

         at_in = changelogname&.scan(/ (\d+)(?: ([+-])(\d{2})(\d{2}))?/)&.first
         if at_in.present?
            seconds = at_in[0].to_i - "#{at_in[1]}#{(at_in[2].to_i * 60 + at_in[3].to_i) * 60}".to_i
            at = Time.at(seconds.to_i)
         end

         {
            email: email,
            name: name,
            login: /@(?<team>packages\.)?altlinux\.org$/ =~ email && login || nil,
            type: team && 'Maintainer::Team' || 'Maintainer::Person',
            at: at
         }
      end

      def import_from_changelogname changelogname
         attrs = parse_changelogname(changelogname)
            Recital::Email.find_or_create_by!(address: attrs[:email]) do |re|
            re.maintainer = Maintainer.new(name: attrs[:name],
                                           login: attrs[:login],
                                           type: attrs[:type],
                                           email: re)
            re.foremost = true
         end.maintainer
      end
   end
end
