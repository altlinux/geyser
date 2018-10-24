# frozen_string_literal: true

class AllBugsForSrpm < Rectify::Query
  attr_reader :srpm

  def initialize(srpm)
    @srpm = srpm
  end

  def query
    Issue::Bug.where(repo_name: components).order(no: :desc)
  end

  def decorate
    BugDecorator.decorate_collection(query)
  end

  private

  def components
    @components ||= srpm.packages.pluck(:name).flatten.sort.uniq
  end
end
