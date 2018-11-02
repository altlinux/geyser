# frozen_string_literal: true

class Group < ApplicationRecord
   has_many :packages
   has_many :spkgs, class_name: 'Package::Src'
   has_many :branch_groups

   scope :root, -> { where("nlevel(groups.path) = 1") }

   validates_presence_of :path
   validates_format_of :path, with: /\A[A-Za-z0-9_\.]+\z/

   before_save :fillin_slug, on: :create

   # scopes
   def groups
      self.class.where("groups.path <@ :path AND groups.path <> :path", path: self.path)
   end

   def children
      groups.where("nlevel(groups.path) = ?", level + 1)
   end

   def uptree
      self.class.where("groups.path @> :path", path: path).order(:path)
   end

   # properties
   def level
      path.count(".") + 1
   end

   def full_name locale = :ru
      prop = locale.to_s == 'en' && :name_en || :name

      uptree.select(prop).pluck(:name).join("/")
   end

   class << self
      def groups
         all
      end
   end

   protected

   def fillin_slug
      self.slug ||= path.downcase.gsub(/\./, '_')
   end
end
