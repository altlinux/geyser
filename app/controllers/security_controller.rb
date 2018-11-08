# frozen_string_literal: true

class SecurityController < ApplicationController
  def index
    @changelogs = @branch.changelogs.fix.includes(:package)
                                        .order('changelogs.at DESC')
                                        .page(params[:page])
                                        .per(50)
    counted_branches = Changelog.fix.joins(:branches)
                                    .select("branches.id as id, count(distinct(changelogs.id)) as maintainer_id")
                                    .group("branches.id")
                                    .order("maintainer_id DESC")

    @branches_s = ActiveModel::Serializer::CollectionSerializer.new(counted_branches,
                                                                    serializer: BranchAsChangelogSerializer).as_json
  end
end
