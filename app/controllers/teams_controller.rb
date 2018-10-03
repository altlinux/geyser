# frozen_string_literal: true

class TeamsController < ApplicationController
  def index
    @branches = Branch.order('order_id')
    @teams = MaintainerTeam.order(:name)
  end

  def show
    @branches = Branch.order('order_id')
    @team = MaintainerTeam.find_by!(login: "@#{ params[:id] }")
    acl_names = @team.acls.in_branch(@branch).select(:package_name).distinct
    @srpms_counter = @branch.spkgs.where(name: acl_names).count
    @srpms = @branch.spkgs.where(name: acl_names)
                    .includes(:repocop_patch)
                    .select('repocop, packages.name, packages.epoch, packages.version, packages.release, packages.buildtime, packages.url, packages.summary')
                    .order('LOWER(packages.name)')
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
                                 LIMIT 1", "@#{ params[:id] }", @branch.name ])
    @members = Team.find_by_sql(['SELECT maintainers.login, maintainers.name
                                  FROM teams, maintainers, branches
                                  WHERE maintainers.id = teams.maintainer_id
                                  AND teams.name = ?
                                  AND teams.branch_id = branches.id
                                  AND branches.name = ?
                                  ORDER BY LOWER(maintainers.name)', "@#{ params[:id] }", @branch.name ])
  end
end
