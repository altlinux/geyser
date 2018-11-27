# frozen_string_literal: true

class OpenedBugsForSrpm < Rectify::Query
  BUG_STATUSES = ['NEW', 'ASSIGNED', 'VERIFIED', 'REOPENED'].freeze

  attr_reader :scope

  def initialize(spkg: nil, branch: nil)
    @scope = AllBugsForSrpm.new(spkg: spkg, branch: branch)
  end

  def query
    scope.query.where(status: BUG_STATUSES).order("no::integer DESC")
  end

  def decorate
    BugDecorator.decorate_collection(query)
  end
end
