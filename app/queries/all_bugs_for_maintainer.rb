# frozen_string_literal: true

class AllBugsForMaintainer < Rectify::Query
  attr_reader :branch, :maintainer

  def initialize(branch, maintainer)
    @branch = branch
    @maintainer = maintainer
  end

  def query
    Bug.where('component IN (?) OR assigned_to = ?', components, maintainer.email).order(bug_id: :desc)
  end

  def decorate
    query.decorate
  end

  private

  def components
    branch.spkgs.where(name: maintainer_packages_names).pluck('name').sort.uniq
  end

  def maintainer_packages_names
    Redis.current.smembers("#{ branch.name }:maintainers:#{ maintainer.login }")
  end
end
