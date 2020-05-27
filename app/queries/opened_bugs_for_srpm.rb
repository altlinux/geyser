# frozen_string_literal: true

class OpenedBugsForSrpm < Rectify::Query
  attr_reader :scope, :spkg, :branch

  def initialize(spkg: nil, branch: nil)
    @scope = AllBugsForSrpm.new(spkg: spkg, branch: branch)
  end

  def query
    scope.query.opened
  end

  def decorate
    BugDecorator.decorate_collection(query&.includes(:branch))
  end
end
