# frozen_string_literal: true

require 'terrapin'

class ImportBranchGroup
   attr_reader :branch, :group_name

   def do
      group = Group.find_or_create_by!(slug: slug) do |g|
         g.path = path
         g.name = name
         g.name_en = name
      end

      BranchGroup.find_or_create_by!(branch_id: branch.id, group_id: group.id)
   end

   def slug
      @slug ||= path.downcase.gsub(/\./, '_')
   end

   def normalized_path
      group_name.gsub(/[\s\.\-\+]+/, '_').gsub(/\//, '.').downcase
   end

   def path
      @path ||= /[А-Яа-я]/ =~ group_name &&
         group_name.split('/').reduce(Group) { |g, t| g.groups.where(name: t).first }&.path ||
         normalized_path
   end

   def name
      @name ||= group_name.split("//").last
   end

   protected

   def initialize branch: nil, group_name: nil
      @group_name = group_name
      @branch = branch
   end
end
