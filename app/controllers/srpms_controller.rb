# frozen_string_literal: true

class SrpmsController < ApplicationController
  before_action :set_version
  before_action :fetch_spkg
  before_action :fetch_spkgs_by_name, only: %i(show changelog spec get)
  before_action :fetch_bugs, only: %i(show changelog spec get)
  before_action :fetch_changelogs, only: %i(show changelog)

  def show
    @ftbfs = @branch.ftbfs.active
                          .where(repo_name: @spkg.name, evr: @spkg.evr)
                          .order(reported_at: :desc)
                          .includes(:branch_path)
    if @spkg.name[0..4] == 'perl-' && @spkg.name != 'perl'
      @perl_watch = PerlWatch.where(name: @spkg.name[5..-1].gsub('-', '::')).first
    end

    @acls = @spkg.acls.in_branch(@branch)
    if @acls.present?
      @maintainers = Maintainer.where(login: @acls.person.maintainer_slugs).order(:name)
      @teams = Maintainer::Team.where(login: @acls.team.maintainer_slugs).order(:name)

      login = @acls.owner.first.maintainer_slug
      @leader = Maintainer.where(login: login).first
    end
  end

  def changelog
  end

  def spec
  end

  def rawspec
    if @spkg.specfile
      send_data @spkg.specfile.spec, disposition: 'attachment', type: 'text/plain', filename: "#{ @spkg.name }.spec"
    else @spkg.specfile.nil?
      render layout: false
    end
  end

  def get
    @mirrors = Mirror.where(branch_id: @branch.id).where("protocol != 'rsync'").order('mirrors.order_id ASC')
    packages = @spkg.all_packages
                    .group("packages.arch, packages.id")
                    .order("packages.name ASC")
    @arched_packages_s = PackagesAsArchedPackagesSerializer.new(packages, branch: @branch)
  end

  protected

  #TODO makeonly created_at when migrate from time to created_at_time
  def fetch_changelogs
     @changelogs = @spkg.changelogs
                        .includes(:maintainer)
                        .order(at: :desc, evr: :desc, created_at: :desc)
  end

  def fetch_spkg
    includes = {
       index: %i(packages),
       rawspec: %i(group branch),
       gear: [gears: :maintainer],
    }[action_name.to_sym]

    spkgs = @branch.spkgs.by_name(params[:reponame]).by_evr(params[:version]).order(buildtime: :desc)
    spkgs = spkgs.includes(*includes) if includes
    
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
