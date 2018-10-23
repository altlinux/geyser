# frozen_string_literal: true

class MiscController < ApplicationController
   def bugs
      @bug_statuses = Issue::Bug.select('DISTINCT status').order('status ASC')
      @resolutions = Issue::Bug.select('DISTINCT resolution').order('resolution ASC')
      @bugs = Issue::Bug.select('status, resolution')
   end
end
