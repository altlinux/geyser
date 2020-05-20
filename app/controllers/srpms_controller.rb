# frozen_string_literal: true

class SrpmsController < ApplicationController
   before_action :set_evrb
   before_action :fetch_spkg, only: %i(show find_first)
   before_action :fetch_spkgs_by_name, only: %i(show)
   before_action :fetch_bugs, only: %i(show)
   before_action :fetch_changelogs, only: %i(show)
   before_action :fetch_branches, only: %i(maintained)
   before_action :fetch_maintainer, only: %i(maintained)
   skip_before_action :set_default_branch, only: %i(find_first)
   #widgets
   before_action :widge_branches, only: %i(index)
   before_action :widge_maintainers, only: %i(index)
   before_action :widge_builds, only: %i(index)
   before_action :widge_srpm_counts, only: %i(index)

   rescue_from 'ActiveRecord::RecordNotFound', with: :redirect_to_home

   def index
      @spkgs = @branch.spkgs.published.uniq_named.includes(:builder, :changelog).ordered.page(params[:page]).per(40).decorate
   end

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

   def maintained
      @all_bugs = BugDecorator.decorate_collection(Issue::Bug.for_maintainer_and_branch(@maintainer, @branch))
      @opened_bugs =  BugDecorator.decorate_collection(@all_bugs.object.opened)
      @spkgs = @branch.spkgs.for_maintainer(@maintainer)
                            .aggregated(select)
                            .includes(:repocop_patch)
                            .reorder(order)
                            .page(params[:page])
                            .per(100)
   end

   def find_first
      redirect_to srpm_url(reponame: @spkg, branch: @spkg.branch, locale: I18n.locale)
   end

   protected

   def select
     order.map { |x| x.is_a?(Hash) && x.keys.first.to_s || x.to_s }.uniq
   end

   def order
      orderlist = [ :name ]

      if params[:sort]
         if params[:order]
            orderlist.unshift(params[:sort] => params[:order])
         else
            orderlist.unshift(params[:sort])
         end
      end

      @contraorder = params[:order] != :desc && :desc || :asc

      orderlist
   end

   #TODO makeonly created_at when migrate from time to created_at_time
   def fetch_changelogs
       @changelogs = @spkg.changelogs
                                    .includes(:maintainer)
                                    .order(at: :desc, evr: :desc, created_at: :desc)
   end

   def fetch_spkg
      @includes = {
          index: %i(packages),
          rawspec: %i(group branch),
          gear: [gears: :maintainer],
      }[action_name.to_sym]

      spkgs = Package::Src.in_branch(@branch).by_name(params[:reponame]).by_evr(@evrb).order(buildtime: :desc)

      spkgs = spkgs.includes(*@includes) if @includes

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

   def fetch_branches
      @branches_s = ActiveModel::Serializer::CollectionSerializer.new(Branch.published,
                                                                      serializer: BranchSerializer)
   end

   def widge_maintainers
      @maintainers_s = ActiveModel::Serializer::CollectionSerializer.new(
         BranchingMaintainer.includes(:maintainer)
                            .top(15, @branch),
         serializer: BranchingMaintainerAsMaintainerSerializer).as_json
   end

   def widge_branches
      @branches_s = BranchPathsToBranchesSerializer.new(BranchPath.includes(:branch)
                                                                  .for_branch(Branch.published.unscope(:order))
                                                                  .published
                                                                  .unanonimous
                                                                  .src
                                                                  .order("branches.order_id DESC, branch_paths.id"))
   end

   def widge_builds
      @spkg_builds = @branch.all_spkgs.top_rebuilds_after(Time.zone.now - 6.months).limit(16)
   end

   def widge_srpm_counts
      @srpm_counts_s = ActiveModel::Serializer::CollectionSerializer.new(
         Package.counted_arches_for(@branch),
         serializer: PackageAsArchCountSerializer).as_json
   end

   def redirect_to_home
      redirect_to home_url(branch: @branch)
   end
end
