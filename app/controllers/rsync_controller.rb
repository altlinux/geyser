# frozen_string_literal: true

class RsyncController < ApplicationController
   def new
      branch = Branch.find_by!(slug: 'sisyphus')
      @branch_groups = branch.branch_groups
                             .joins(:group)
                             .includes(:group)
                             .order('groups.slug')
   end

   def generate
      @branch = Branch.find_by!(slug: 'sisyphus')
      spkg_names = @branch.spkgs.joins(:group).where(group_id: params[:group_ids]).select(:name).distinct.pluck(:name)

      render plain: spkg_names.map {|n| "#{n}-*" }.join("\n")
   end
end
