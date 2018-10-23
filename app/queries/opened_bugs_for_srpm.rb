# frozen_string_literal: true

class OpenedBugsForSrpm < Rectify::Query
  BUG_STATUSES = ['NEW', 'ASSIGNED', 'VERIFIED', 'REOPENED'].freeze

  attr_reader :scope

  def initialize(srpm)
    @scope = AllBugsForSrpm.new(srpm)
  end

  def query
    scope.query.where(status: BUG_STATUSES).order(no: :desc)
  end

  def decorate
    BugDecorator.decorate_collection(query)
  end
end
