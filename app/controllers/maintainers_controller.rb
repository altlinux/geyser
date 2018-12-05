# frozen_string_literal: true

class MaintainersController < ApplicationController
   before_action :set_bug_lists, except: %i(index)
   before_action :set_branches, only: %i(index show)

   def index
      @branching_people = BranchingMaintainer.person
                                             .useful
                                             .for_branch(@branch)
                                             .includes(:maintainer, :branch)
                                             .order("maintainers.name")
   end

   def show
      @acl_count = maintainer.acl_names.count
   end

   protected

   def acl_names
      @acl_names ||= maintainer.acl_names
   end

   def maintainer
      @maintainer ||= Maintainer.find_by!(login: params[:login].downcase).decorate
   end

   def order
      order  = ''
      order += 'LOWER(packages.name)' if sort_column == 'name'
      order += ' buildtime' if sort_column == 'age'
      order += ' repocop_status' if sort_column == 'status'
   end

   def set_bug_lists
      @all_bugs = BugDecorator.decorate_collection(Issue::Bug.for_maintainer_and_branch(maintainer, @branch))
      @opened_bugs =  BugDecorator.decorate_collection(@all_bugs.object.opened)
   end

   def set_branches
      @branches = Branch.published
   end
end
