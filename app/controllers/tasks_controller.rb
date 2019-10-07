# frozen_string_literal: true

class TasksController < ApplicationController
   before_action :fetch_maintainer, only: %i(index)
   before_action :fetch_bug_lists, only: %i(index)
   before_action :set_branches, only: %i(index)
   before_action :set_evrb, only: %i(pkg_index)
   before_action :fetch_spkg, only: %i(pkg_index)
   before_action :fetch_spkgs_by_name, only: %i(pkg_index)
   before_action :fetch_bugs, only: %i(pkg_index)

   def index
      @tasks = @maintainer.tasks.includes(:branch)
   end

   def pkg_index
      @tasks = @spkg.tasks.includes(:branch, :owner)
   end

   protected

   def set_branches
      @branches_s = ActiveModel::Serializer::CollectionSerializer.new(Branch.published,
                                                                      serializer: BranchSerializer)
   end

   def fetch_maintainer
      @maintainer ||= Maintainer.find_by!(login: params[:login].downcase).decorate
   end

   def fetch_bug_lists
      @all_bugs = BugDecorator.decorate_collection(Issue::Bug.for_maintainer_and_branch(@maintainer, @branch))
      @opened_bugs =  BugDecorator.decorate_collection(@all_bugs.object.opened)
   end

   def fetch_spkg
      spkgs = @branch.spkgs.by_name(params[:reponame]).by_evr(params[:evrb]).order(buildtime: :desc)

      @spkg = spkgs.first!.decorate
   end

   def fetch_spkgs_by_name
      @spkgs_by_name = SrpmBranchesSerializer.new(Rpm.src
                                                     .by_name(params[:reponame])
                                                     .joins(:branch)
                                                     .merge(Branch.published)
                                                     .includes(:branch_path, :branch, :package)
                                                     .order('packages.buildtime DESC, branches.order_id'))
   end

   def set_evrb
      @evrb = params[:evrb]
   end

   def fetch_bugs
      @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
      @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
   end
end