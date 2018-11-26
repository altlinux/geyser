# frozen_string_literal: true

class IssuesController < ApplicationController
  before_action :fetch_spkg
  before_action :fetch_spkgs_by_name
  before_action :fetch_bugs

  def bugs
  end

  def repocops
  end

  protected

  #TODO makeonly created_at when migrate from time to created_at_time
  def fetch_changelogs
     @changelogs = @spkg.changelogs
                        .includes(:maintainer)
                        .order(at: :desc, evr: :desc, created_at: :desc)
  end

  def fetch_spkg
    spkgs = @branch.spkgs.by_name(params[:reponame]).by_evr(params[:version]).order(buildtime: :desc)

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

  def set_version
    @version = params[:version]
  end

  def fetch_bugs
    @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
    @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
  end
end
