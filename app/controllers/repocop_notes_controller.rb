# frozen_string_literal: true

class RepocopNotesController < ApplicationController
   before_action :set_evrb, only: %i(index)
   before_action :fetch_spkg, only: %i(index)
   before_action :fetch_spkgs_by_name, only: %i(index)
   before_action :fetch_bugs, only: %i(index)
   before_action :fetch_maintainer, only: %i(maintained)
   before_action :fetch_maintainer_bugs, only: %i(maintained)

   def index
      @repocop_notes = @spkg.repocop_notes.includes(:package)
   end

   def maintained
      @repocop_notes = @maintainer.repocop_notes.buggy.includes(:spkg, :package)
   end

   protected

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

   def fetch_maintainer
      @maintainer = Maintainer.find_by!(login: params[:login].downcase).decorate
   end

   def fetch_maintainer_bugs
      @all_bugs = BugDecorator.decorate_collection(Issue::Bug.for_maintainer_and_branch(@maintainer, @branch))
      @opened_bugs =  BugDecorator.decorate_collection(@all_bugs.object.opened)
   end
end
