# frozen_string_literal: true

class AllBugsForSrpm < Rectify::Query
  attr_reader :srpm

  def initialize(srpm)
    @srpm = srpm
  end

  def query
    Bug.where(component: components).order(bug_id: :desc)
  end

  def decorate
    query.decorate
  end

  private

  def components
    @components ||= srpm.packages.pluck(:name).flatten.sort.uniq
  end
end
