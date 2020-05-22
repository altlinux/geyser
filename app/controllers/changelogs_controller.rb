# frozen_string_literal: true

class ChangelogsController < ApplicationController
  include Srpmable

  before_action :fetch_spkg
  before_action :fetch_spkgs_by_name
  before_action :fetch_bugs

  def index
     @changelogs = @spkg.changelogs
                        .includes(:maintainer)
                        .order(at: :desc, evr: :desc, created_at: :desc)
  end

  protected

  def fetch_bugs
    @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
    @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
  end
end
