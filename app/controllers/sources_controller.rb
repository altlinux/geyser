# frozen_string_literal: true

class SourcesController < ApplicationController
   before_action :set_evrb
   before_action :fetch_spkg
   before_action :fetch_spkgs_by_name, only: %i(index)
   before_action :fetch_bugs, only: :index

   def index
      @sources = Source.where(package: @spkgs).presented.uniq_by(:content)
   end

   protected

   def fetch_spkg
      @spkgs = @branch.spkgs.by_name(params[:reponame]).by_evr(params[:evrb]).order(buildtime: :desc)

      @spkg = @spkgs.first!
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
