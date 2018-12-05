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
    @leader = Team.find_by_sql(["SELECT maintainers.login, maintainers.name
                                 FROM teams, maintainers, branches
                                 WHERE maintainers.id = teams.maintainer_id
                                 AND teams.name = ?
                                 AND teams.branch_id = branches.id
                                 AND branches.name = ?
                                 AND leader = 'true'
                                 LIMIT 1", "@#{ params[:login] }", @branch.name ])
    @members = Team.find_by_sql(['SELECT maintainers.login, maintainers.name
                                  FROM teams, maintainers, branches
                                  WHERE maintainers.id = teams.maintainer_id
                                  AND teams.name = ?
                                  AND teams.branch_id = branches.id
                                  AND branches.name = ?
                                  ORDER BY LOWER(maintainers.name)', "@#{ params[:login] }", @branch.name ])
  end
end
