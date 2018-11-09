# frozen_string_literal: true

class RepocopPatchesController < ApplicationController
   layout false

   before_action :fetch_repocop_patch

   def download
      send_data @repocop_patch.text, disposition: 'attachment', filename: @repocop_patch.filename
   end

   protected

   def fetch_repocop_patch
      @repocop_patch = RepocopPatch.find_by!(package_id: params[:repocop_patch_package_id])
   end
end
