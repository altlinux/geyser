# frozen_string_literal: true

class SearchesController < ApplicationController
  before_action :fix_arches
  before_action :set_branch

  def show
    @branches = Branch.all
    if params[:query].blank? and params[:arch].blank?
      redirect_to controller: 'home', action: 'index'
    else
      @spkgs = Package::Src.b(@branch.slug)
                           .a(@arches)
                           .q(params[:query])
                           .reorder("packages.name, packages.epoch DESC, packages.version DESC, packages.release DESC")
                           .includes(:branches, :rpms)
                           .distinct
                           .page(params[:page])

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

  def set_branch
     @branch = Branch.find_or_initialize_by(slug: params[:branch]).decorate
  end
end
