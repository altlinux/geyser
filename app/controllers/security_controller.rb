# frozen_string_literal: true

class SecurityController < ApplicationController
  def index
    @changelogs = @branch.all_changelogs.fix
                                        .includes(:package)
                                        .order('changelogs.at DESC')
                                        .page(params[:page])
                                        .per(50)
    counted_branches = Changelog.fix.joins(:branches)
                                    .merge(Branch.published)
                                    .select("branches.id as id, branches.order_id, count(distinct(changelogs.id)) as maintainer_id")
                                    .group("branches.id")
                                    .order("maintainer_id DESC")

    @branches_s = ActiveModel::Serializer::CollectionSerializer.new(counted_branches,
                                                                    serializer: BranchAsChangelogSerializer).as_json
  end
end
