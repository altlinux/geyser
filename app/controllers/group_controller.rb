# frozen_string_literal: true

class GroupController < ApplicationController
   before_action :fetch_branch_group, only: :show
   before_action :fetch_branches
   before_action :permit

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

   def permit
      @params = params.permit(:controller, :action, :locale, :branch)
   end

   def fetch_branches
      @branches_s = ActiveModel::Serializer::CollectionSerializer.new(Branch.published,
                                                                      serializer: BranchSerializer)
   end
end
