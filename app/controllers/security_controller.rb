# frozen_string_literal: true

class SecurityController < ApplicationController
  def index
    @changelogs = @branch.changelogs.where("changelogs.changelogtext LIKE '%CVE%'").includes(:package).order('changelogs.at DESC').page(params[:page]).per(50)
  end
end
