# frozen_string_literal: true

class RpmsController < ApplicationController
   include Srpmable

   before_action :set_evrb
   before_action :fetch_spkg, only: %i(index)
   before_action :fetch_spkgs_by_name, only: %i(index)
   before_action :fetch_bugs, only: %i(index)

   def index
      @mirrors = Mirror.where(branch_id: @branch.id).where("protocol != 'rsync'").order('mirrors.order_id ASC')
      packages = Package.by_source(@spkgs)
                        .in_branch(@branch)
                        .group("packages.arch, packages.id")
                        .order("packages.name ASC")
      @arched_packages_s = PackagesAsArchedPackagesSerializer.new(packages, branch: @branch)
   end

   protected

   def set_evrb
      @evrb = params[:evrb]
   end

   def fetch_bugs
      @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
      @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
   end
end
