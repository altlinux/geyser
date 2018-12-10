# frozen_string_literal: true

class TeamsController < ApplicationController
  def index
    @branches = Branch.published
    @branching_teams = BranchingMaintainer.team
                                          .useful
                                          .for_branch(@branch)
                                          .includes(:maintainer, :branch)
                                          .order("maintainers.name")
  end

  def show
    @branches = Branch.published
    @team = Maintainer::Team.find_by!(login: "@#{ params[:login] }")
    acl_names = @team.acls.in_branch(@branch).select(:package_name).distinct
    @spkgs_counter = @branch.spkgs.where(name: acl_names).count
    @spkgs = @branch.spkgs.where(name: acl_names)
                    .includes(:repocop_patch)
                    .select('DISTINCT(packages.*), repocop_status, lower(packages.name)')
                    .order('lower(packages.name)')
                    .page(params[:page])
                    .per(100)
                    .decorate
    @members = @team.people
    @leader = @team.leader
  end
end
