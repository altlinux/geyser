# frozen_string_literal: true

class PatchesController < ApplicationController
    before_action :set_version, except: :download
    before_action :fetch_spkg, except: :download
    before_action :fetch_spkgs_by_name, only: %i(index)
    before_action :fetch_patch, only: :download

   def index
      @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
      @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
   end

   def show
      @patch = @spkg.patches.find_by!(filename: params[:name])
      raise ActiveRecord::RecordNotFound unless @patch.patch

      @html_data = Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight', line_numbers: true).format(Rouge::Lexers::Diff.new.lex(@patch.patch))
   end

   def download
      send_data(@patch.patch, disposition: 'attachment', filename: @patch.filename)
   end

   protected

   def fetch_spkg
      includes = {
          index: %i(patches),
      }[action_name.to_sym]

      srpms = @branch.spkgs.by_name(params[:name]).by_evr(@version).order(buildtime: :desc)
      srpms = srpms.includes(*includes) if includes
      
      @spkg = srpms.first!.decorate
   end

   def fetch_spkgs_by_name
      @spkgs_by_name = SrpmBranchesSerializer.new(Rpm.src
                                                                            .by_name(params[:name])
                                                                            .includes(:branch_path, :package, :branch)
                                                                            .order('packages.buildtime DESC, branches.order_id'))
   end

   def set_version
      @version = params[:evrb]
   end

    def package_attrs
         /(?:(?<epoch>\d+):)?(?<version>[^-]+)-(?<release>[^-]+)-(?<built_at>\d+)$/ =~ params[:evrb]

         {
             name: params[:name],
             epoch: epoch,
             version: version,
             release: release,
             arch: "src",
             buildtime: Time.at(built_at.to_i)
         }
    end

    def fetch_patch
         @patch = Patch.joins(:package)
                              .where(filename: params[:patch_name],
                                        packages: package_attrs)&.first
         @patch.patch? && @patch || raise(ActiveRecord::RecordNotFound)
    end
end
