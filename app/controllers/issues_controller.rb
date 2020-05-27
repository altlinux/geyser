# frozen_string_literal: true

class IssuesController < ApplicationController
   include Srpmable

   before_action :set_evrb, only: :index
   before_action :fetch_spkg, only: :index
   before_action :fetch_spkgs_by_name, only: :index
   before_action :fetch_bugs, only: :index
   before_action :set_branches, only: %i(bugs novelties ftbfses)
   before_action :fetch_maintainer, only: %i(bugs novelties ftbfses)
   before_action :fetch_maintainer_bugs, only: %i(bugs novelties ftbfses)

   has_scope :b

   def index
      if params[:q] == 'all'
         @issues = @all_bugs
      else
         @issues = @opened_bugs
      end
   end

   def bugs
      if params[:q] == 'all'
         @issues = @all_bugs
      else
         @issues = @opened_bugs
      end
   end

   def novelties
      @frs = Issue::Novelty.active
                           .joins(:issue_assignees)
                           .where(issue_assignees: { maintainer_id: @maintainer })
                           .includes(:branch)
                           .order(reported_at: :asc, repo_name: :asc)
   end

   def ftbfses
      @ftbfs = Issue::Ftbfs.active
                           .joins(:issue_assignees)
                           .where(issue_assignees: { maintainer_id: @maintainer })
                           .includes(:branch)
                           .order(reported_at: :asc, repo_name: :asc)
   end

   protected

   #TODO makeonly created_at when migrate from time to created_at_time
   def fetch_changelogs
      @changelogs = @spkg.changelogs
                         .includes(:maintainer)
                         .order(at: :desc, evr: :desc, created_at: :desc)
   end

   def set_evrb
      @evrb = params[:evrb]
   end

   def set_branches
      @branches_s = ActiveModel::Serializer::CollectionSerializer.new(Branch.published,
                                                                      serializer: BranchSerializer)
   end

   def fetch_bugs
      @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
      @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
   end

   def fetch_maintainer
      @maintainer = Maintainer.find_by!(login: params[:login].downcase).decorate
   end

   def fetch_maintainer_bugs
      @all_bugs = BugDecorator.decorate_collection(Issue::Bug.for_maintainer_and_branch(@maintainer, @branch))
      @opened_bugs =  BugDecorator.decorate_collection(@all_bugs.object.opened)
   end
end
