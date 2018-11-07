# frozen_string_literal: true

class PatchesController < ApplicationController
  before_action :set_version
  before_action :fetch_spkg
  before_action :fetch_spkgs_by_name, only: %i(index)

  def index
    @all_bugs = AllBugsForSrpm.new(@spkg).decorate
    @opened_bugs = OpenedBugsForSrpm.new(@spkg).decorate
  end

  def show
    @patch = @spkg.patches.find_by!(filename: params[:id])
    raise ActiveRecord::RecordNotFound unless @patch.patch
    # @html_data = Rouge::Formatters::HTML.new(css_class: 'highlight', line_numbers: true, inline_theme: 'github').format(Rouge::Lexers::Diff.new.lex(@patch.patch))

    @html_data = Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight', line_numbers: true).format(Rouge::Lexers::Diff.new.lex(@patch.patch))
  end

  protected

  def fetch_spkg
    includes = {
       index: %i(patches),
    }[action_name.to_sym]

    srpms = @branch.spkgs.by_name(params[:srpm_id]).by_evr(params[:version]).order(buildtime: :desc)
    srpms = srpms.includes(*includes) if includes
    
    @spkg = srpms.first!.decorate
  end

  def fetch_spkgs_by_name
    @spkgs_by_name = SrpmBranchesSerializer.new(Rpm.src.by_name(params[:srpm_id]).includes(:branch_path, :package, :branch).order('packages.buildtime DESC, branches.order_id'))
  end

  def set_version
    @version = params[:version]
  end
end
