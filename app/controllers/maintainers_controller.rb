# frozen_string_literal: true

class MaintainersController < ApplicationController
   before_action :set_srpms, only: %i(srpms bugs allbugs repocop)
   before_action :set_bug_lists, except: %i(index)
   before_action :set_branches, only: %i(index show srpms)

   def index
      @branching_people = BranchingMaintainer.person
                                             .useful
                                             .for_branch(@branch)
                                             .includes(:maintainer, :branch)
                                             .order("maintainers.name")
   end

   def show
      @acl_count = maintainer.acl_names.count
   end

#  def acls
#    @acls = Acl.all :conditions => {
#                      :maintainer_slug => params[:login],
#                      :branch_id => @branch.id }
#  end

   def gear
      @gears = Gear.joins(:gear_maintainers).for_maintainer(@maintainer).order(changed_at: :desc)
   end

   def bugs
   end

   def allbugs
   end

   def feature_requests
      @frs = Issue::FeatureRequest.active
                                  .joins(:issue_assignees)
                                  .where(issue_assignees: { maintainer_id: maintainer })
                                  .includes(:branch)
                                  .order(reported_at: :asc, repo_name: :asc)
   end

   def ftbfs
      @ftbfs = Issue::Ftbfs.active
                           .joins(:issue_assignees)
                           .where(issue_assignees: { maintainer_id: maintainer })
                           .includes(:branch)
                           .order(reported_at: :asc, repo_name: :asc)
   end

   def repocop
   end

   protected

   def acl_names
      @acl_names ||= maintainer.acl_names
   end

   def maintainer
      @maintainer ||= Maintainer.find_by!(login: params[:id].downcase).decorate
   end

   def order
      order  = ''
      order += 'LOWER(packages.name)' if sort_column == 'name'
      order += 'buildtime' if sort_column == 'age'

      if sort_column == 'status'
         order += "CASE repocop
                   WHEN 'skip'         THEN 1
                   WHEN 'ok'           THEN 2
                   WHEN 'experimental' THEN 3
                   WHEN 'info'         THEN 4
                   WHEN 'warn'         THEN 5
                   WHEN 'fail'         THEN 6
                   END"
      end

      order += ' ' + sort_order
   end

   def set_bug_lists
      @all_bugs = BugDecorator.decorate_collection(Issue::Bug.for_maintainer_and_branch(maintainer, @branch))
      @opened_bugs =  BugDecorator.decorate_collection(@all_bugs.object.opened)
   end

   def set_srpms
      @srpms = @branch.spkgs.where(name: acl_names)
                      .includes(:repocop_patch)
                      .order(order)
                      .page(params[:page])
                      .per(100)
                      .select('DISTINCT(packages.*), LOWER(packages.name)')
                      .decorate
   end

   def set_branches
      @branches = Branch.all
   end
end
