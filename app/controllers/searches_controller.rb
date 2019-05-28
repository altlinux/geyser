# frozen_string_literal: true

class SearchesController < ApplicationController
   before_action :fix_arches
   before_action :set_branch

   def show
      @branches = Branch.all
      if params[:query].blank? and params[:arch].blank?
         redirect_to controller: 'home', action: 'index'
      else
         spkgs = Package::Src.b(@branch.slug)
                             .a(@arches)
                             .q(params[:query])
                             .unscope(:select)
                             .includes(:branch)

         @spkgs = spkgs.order(order_for_sql(spkgs))
                       .select(select_for_sql(spkgs))
                       .page(params[:page])

         if @spkgs.total_count == 1 && @spkgs.first.branches.first
           redirect_to(srpm_path(@spkgs.first.branches.first, @spkgs.first), status: 302)
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

   def on_filter
      %w(branches.order_id)
   end

   def select_for_sql q
      order = q.order_values.map { |x| x.split(/, ?/).map { |y| y.split(' ').first} }.flatten.reject { |x| on_filter.include?(x) }

      on = %w(packages.name) | order
      rows = %w(packages.* branches.slug) | order

      "DISTINCT on(#{on.join(', ')}) #{rows.join(', ')}"
   end

   def order_for_sql q
      order_parts = [ "packages.name", "packages.buildtime DESC", "branches.order_id DESC" ]
      order_prim_parts = q.order_values.map { |x| x.split(/, ?/) }.flatten.reject { |x| on_filter.include?(x.split(/ +/).first) }

      (order_prim_parts | order_parts).join(", ")
   end
end
