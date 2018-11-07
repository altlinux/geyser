# frozen_string_literal: true

class SourcesController < ApplicationController
  before_action :set_version
  before_action :fetch_spkg
  before_action :fetch_spkgs_by_name, only: %i(index)

  def index
    @sources = Source.where(package: @spkg).select('filename, size, source')
    @all_bugs = AllBugsForSrpm.new(@spkg).decorate
    @opened_bugs = OpenedBugsForSrpm.new(@spkg).decorate
  end

  protected

  def fetch_spkg
    spkgs = @branch.spkgs.by_name(params[:srpm_id]).by_evr(params[:version]).order(buildtime: :desc)

    @spkg = spkgs.first!.decorate
  end

  def fetch_spkgs_by_name
    @spkgs_by_name = SrpmBranchesSerializer.new(Rpm.src.by_name(params[:srpm_id]).includes(:branch_path, :branch, :package).order('packages.buildtime DESC, branches.order_id'))
  end

  def set_version
    @version = params[:version]
  end
end
