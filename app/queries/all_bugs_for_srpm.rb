# frozen_string_literal: true

class AllBugsForSrpm < Rectify::Query
  attr_reader :spkg, :branch

  def initialize(spkg: nil, branch: nil)
    @spkg = spkg
    @branch = branch
  end

  def query
    Issue::Bug.s(spkg)
              .where(branch_path_id: branch.branch_paths.select(:id))
              .order(Arel.sql("no::integer DESC"))
  end

  def decorate
    BugDecorator.decorate_collection(query&.includes(:branch))
  end
end
