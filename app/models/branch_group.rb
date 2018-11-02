# frozen_string_literal: true

class BranchGroup < ApplicationRecord
   belongs_to :branch
   belongs_to :group

   has_many :spkgs, ->(this) { where(group_id: this.group_id).distinct }, class_name: 'Package::Src', through: :branch

   scope :root, -> { joins(:group).merge(Group.root) }
   scope :with_parent, ->(parent) { parent && self.merge(parent.children) || root }
   scope :with_slug, ->(slug) { joins(:group).merge(Group.where(slug: slug)) }

   delegate :full_name, :name, to: :group

   def children
      self.class.joins(:group).merge(group.children).where("branch_groups.group_id = groups.id")
   end

   def leaf?
      children.blank?
   end

   def name_for locale
      locale.to_s == 'en' && group.name_en || group.name
   end
end
