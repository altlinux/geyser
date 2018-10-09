# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :fix_arches

  def show
    @branches = Branch.all
    if params[:query].blank? and params[:arch].blank?
      redirect_to controller: 'home', action: 'index'
    else
      @spkgs = Package::Src.b(params[:branch]).a(@arches).q(params[:query]).reorder("packages.name").distinct.page(params[:page])

      if @spkgs.total_count == 1
        redirect_to(srpm_path(@branch, @spkgs.first), status: 302)
      end
    end
  end

  protected

  # fixes noarch arch call when blank TODO
  def fix_arches
    arches = [ params[:arch] ].flatten.compact.select { |a| a.present? }
    @arches = arches.any? { |a| a != 'noarch' } && arches || nil
  end
end
