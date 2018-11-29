# frozen_string_literal: true

class SrpmsController < ApplicationController
   before_action :set_evrb
   before_action :fetch_spkg, only: %i(show)
   before_action :fetch_spkgs_by_name, only: %i(show)
   before_action :fetch_bugs, only: %i(show)
   before_action :fetch_changelogs, only: %i(show)

   def index
      @branches = Branch.filled
      @spkg_builds = @branch.all_spkgs.top_rebuilds_after(Time.zone.now - 6.months).limit(16)
      @branches_s = BranchPathsToBranchesSerializer.new(BranchPath.includes(:branch)
                                                                  .for_branch(@branches)
                                                                  .published
                                                                  .unanonimous
                                                                  .src
                                                                  .order("branches.order_id DESC, branch_paths.id"))
      @maintainers_s = ActiveModel::Serializer::CollectionSerializer.new(BranchingMaintainer.includes(:maintainer).top(15, @branch), serializer: BranchingMaintainerAsMaintainerSerializer).as_json
      @spkgs = @branch.spkgs.includes(:builder).ordered.page(params[:page]).per(40).decorate
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

      spkgs = @branch.spkgs.by_name(params[:reponame]).by_evr(@evrb).order(buildtime: :desc)
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

   def set_evrb
      @evrb = params[:evrb]
   end

   def fetch_bugs
      @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
      @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
   end
end
