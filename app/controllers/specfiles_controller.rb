# frozen_string_literal: true

class SpecfilesController < ApplicationController
   include Srpmable

   before_action :set_evrb
   before_action :fetch_spkg
   before_action :fetch_spkgs_by_name, only: :show
   before_action :fetch_bugs, only: :show

   def show
   end

   def raw
      if @spkg.specfile
         send_data @spkg.specfile.spec, disposition: 'attachment', type: 'text/plain', filename: "#{ @spkg.name }.spec"
      else @spkg.specfile.nil?
         render layout: false
      end
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
