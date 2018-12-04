# frozen_string_literal: true

class GearsController < ApplicationController
   before_action :fetch_maintainer
   before_action :fetch_bug_lists

   def index
      @gears = Gear.joins(:gear_maintainers).for_maintainer(@maintainer).order(changed_at: :desc)
   end

   protected

   def fetch_maintainer
      @maintainer ||= Maintainer.find_by!(login: params[:login].downcase).decorate
   end

   def fetch_bug_lists
      @all_bugs = BugDecorator.decorate_collection(Issue::Bug.for_maintainer_and_branch(@maintainer, @branch))
      @opened_bugs =  BugDecorator.decorate_collection(@all_bugs.object.opened)
   end
end
