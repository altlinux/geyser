# frozen_string_literal: true

class SrpmsController < ApplicationController
  before_action :set_version
  before_action :fetch_srpm
  before_action :fetch_srpms_by_name, only: %i(show changelog spec get)

  def show
    @ftbfs = @branch.ftbfs.where(name: @spkg.name,
                                 version: @spkg.version,
                                 release: @spkg.release,
                                 epoch: @spkg.epoch).select('DISTINCT id, arch, weeks')
    @changelogs = @spkg.changelogs.order(created_at: :asc).limit(3)
    if @spkg.name[0..4] == 'perl-' && @spkg.name != 'perl'
      @perl_watch = PerlWatch.where(name: @spkg.name[5..-1].gsub('-', '::')).first
    end

    @acls = @spkg.acls.in_branch(@branch)
    if @acls.present?
      @maintainers = Maintainer.where(login: @acls.people.maintainer_slugs).order(:name)
      @teams = MaintainerTeam.where(login: @acls.teams.maintainer_slugs).order(:name)

      login = @acls.owner.first.maintainer_slug
      if login[0] == '@'
        @leader = MaintainerTeam.where(login: login).first
      else
        @leader = Maintainer.where(login: login).first
      end
    end

    @all_bugs = AllBugsForSrpm.new(@spkg).decorate
    @opened_bugs = OpenedBugsForSrpm.new(@spkg).decorate
  end

  def changelog
    @changelogs = @spkg.changelogs.order('changelogs.created_at ASC')
    @all_bugs = AllBugsForSrpm.new(@spkg).decorate
    @opened_bugs = OpenedBugsForSrpm.new(@spkg).decorate
  end

  def spec
    @all_bugs = AllBugsForSrpm.new(@spkg).decorate
    @opened_bugs = OpenedBugsForSrpm.new(@spkg).decorate
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
    packages = @spkg.packages.order('packages.name ASC').group("packages.arch, packages.id")
    @arched_packages_s = PackagesAsArchedPackagesSerializer.new(packages, branch: @branch)
    @all_bugs = AllBugsForSrpm.new(@spkg).decorate
    @opened_bugs = OpenedBugsForSrpm.new(@spkg).decorate
  end

  def gear
    @all_bugs = AllBugsForSrpm.new(@spkg).decorate
    @opened_bugs = OpenedBugsForSrpm.new(@spkg).decorate
  end

  protected

  def fetch_srpm
    includes = {
       index: %i(packages),
       rawspec: %i(group branch),
       gear: [gears: :maintainer],
    }[action_name.to_sym]

    spkgs = @branch.spkgs.where(name: params[:id]).by_evr(params[:version])
    spkgs = spkgs.includes(*includes) if includes
    
    @spkg = spkgs.first!.decorate
  end

  def fetch_srpms_by_name
    @spkgs_by_name = SrpmBranchesSerializer.new(Rpm.by_name(params[:id]).includes(:branch_path, :branch, :package).order('branches.order_id'))
  end

  def set_version
    @version = params[:version]
  end
end
