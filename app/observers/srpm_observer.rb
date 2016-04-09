class SrpmObserver < ActiveRecord::Observer
  def after_create(srpm)
    increment_branch_counter(srpm)

    add_filename_to_cache(srpm)
  end

  def after_destroy(srpm)
    decrement_branch_counter(srpm)

    remove_filename_from_cache(srpm)
  end

  private

  def increment_branch_counter(srpm)
    srpm.branch.counter.increment
  end

  def decrement_branch_counter(srpm)
    srpm.branch.counter.decrement
  end

  def add_filename_to_cache(srpm)
    Redis.current.set("#{ srpm.branch.name }:#{ srpm.filename }", 1)
  end

  def remove_filename_from_cache(srpm)
    Redis.current.del("#{ srpm.branch.name }:#{ srpm.filename }")
  end

  # after_create :add_filename_to_cache
  #
  # after_destroy :remove_filename_from_cache
  #
  # after_destroy :remove_acls_from_cache
  #
  # after_destroy :remove_leader_from_cache

  # def add_filename_to_cache
  #   Redis.current.set("#{ branch.name }:#{ filename }", 1)
  # end
  #
  # def remove_filename_from_cache
  #   Redis.current.del("#{ branch.name }:#{ filename }")
  # end
  #
  # def remove_acls_from_cache
  #   Redis.current.del("#{ branch.name }:#{ name }:acls")
  # end
  #
  # def remove_leader_from_cache
  #   Redis.current.del("#{ branch.name }:#{ name }:leader")
  # end
end
