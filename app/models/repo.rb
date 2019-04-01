# frozen_string_literal: true

class Repo < ApplicationRecord
   belongs_to :holder, primary_key: :login, foreign_key: :holder_slug, class_name: 'Maintainer', optional: true

   has_many :repo_tags
   has_many :tags, -> { order(authored_at: :desc) }, through: :repo_tags
   has_many :authors, -> { select("DISTINCT ON(maintainers.id) maintainers.*, tags.authored_at").order(:id) }, through: :tags, class_name: 'Maintainer'
   has_many :taggers, -> { select("DISTINCT ON(maintainers.id) maintainers.*, tags.authored_at").order(:id) }, through: :tags, class_name: 'Maintainer'

   scope :alt, -> { where(kind: %w(srpm gear)) }
   scope :person, -> { where(kind: 'person') }
   scope :gear, -> { where(kind: 'gear') }
   scope :srpm, -> { where(kind: 'srpm') }

   validates_presence_of :name, :uri, :path, :kind, :changed_at

   def path_for prefix
      "#{prefix}/#{kind.pluralize}/#{name[0]}/#{name}.git"
   end

   def reponame
      name
   end

   def associative
      holder || authors.first || taggers.first
   end

   class << self
      def changed_at scope
         self.send(scope).select("max(#{table_name}.changed_at) as changed_at")[0].read_attribute(:changed_at)
      end
   end
end
