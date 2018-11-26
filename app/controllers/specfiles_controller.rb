# frozen_string_literal: true

class SpecfilesController < ApplicationController
  before_action :fetch_spkg
  before_action :fetch_spkgs_by_name, only: :show
  before_action :fetch_bugs, only: :show

  def show
  end

  def raw
    if @spkg.specfile
      send_data @spkg.specfile.spec, disposition: 'attachment', type: 'text/plain', filename: "#{ @spkg.name }.spec"
    else @spkg.specfile.nil?
      render layout: false
    end
  end

  protected

  def fetch_spkg
    spkgs = @branch.spkgs.by_name(params[:reponame]).by_evr(params[:evrb]).order(buildtime: :desc)
    spkgs = spkgs.includes(*%i(group branch))
    
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

  def fetch_bugs
    @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
    @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
  end
end
