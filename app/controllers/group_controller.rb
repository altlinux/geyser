# frozen_string_literal: true

class GroupController < ApplicationController
   before_action :fetch_branch_group, only: :show

   def index
      @branch_groups = @branch.branch_groups.order('groups.slug')
   end

   def show
      @spkgs = @branch_group.spkgs
                            .includes(:changelog)
                            .select("packages.*, LOWER(packages.name)")
                            .reorder('LOWER(packages.name)')
                            .page(params[:page])
                            .per(1_000)
                            .decorate
   end

   protected

   def fetch_branch_group
      @branch_group = @branch.branch_groups.with_slug(params[:slug]).first || raise(ActiveRecord::RecordNotFound)
   end
end
