# frozen_string_literal: true

class BranchGroup < ApplicationRecord
   belongs_to :branch
   belongs_to :group

   has_many :spkgs, ->(this) do
      group_ids = this.group.tree.select(:id)
      where(group_id: group_ids).distinct
      end, class_name: 'Package::Src', through: :branch
   has_many :srpms, through: :spkgs, source: :rpms

   scope :root, -> { joins(:group).merge(Group.root) }
   scope :with_parent, ->(parent) { parent && self.merge(parent.children) || root }
   scope :with_slug, ->(slug) { joins(:group).merge(Group.where(slug: slug)) }

   delegate :full_name, :name, to: :group

   # scope

   def children
      self.class.joins(:group).merge(group.children).where("branch_groups.group_id = groups.id")
   end

   # prop

   def leaf?
      children.blank?
   end

   def name_for locale = :ru
      locale.to_s == 'en' && group.name_en || group.name
   end
end
