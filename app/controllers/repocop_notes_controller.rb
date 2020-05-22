# frozen_string_literal: true

class RepocopNotesController < ApplicationController
   include Srpmable

   before_action :set_evrb, only: %i(index)
   before_action :fetch_spkg, only: %i(index)
   before_action :fetch_spkgs_by_name, only: %i(index)
   before_action :fetch_bugs, only: %i(index)
   before_action :fetch_maintainer, only: %i(maintained)
   before_action :fetch_maintainer_bugs, only: %i(maintained)
   before_action :set_branches, only: %i(maintained)

   def index
      @repocop_notes = @spkg.repocop_notes.includes(:package).order(status: :desc, kind: :asc)
   end

   def maintained
      @repocop_notes = @maintainer.repocop_notes.buggy.includes(:spkg, :package).order(status: :desc, kind: :asc)
   end

   protected

   def set_branches
      @branches_s = ActiveModel::Serializer::CollectionSerializer.new(Branch.published,
                                                                      serializer: BranchSerializer)
   end

   def set_evrb
      @evrb = params[:evrb]
   end

   def fetch_bugs
      @all_bugs = AllBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
      @opened_bugs = OpenedBugsForSrpm.new(spkg: @spkg, branch: @branch).decorate
   end

   def fetch_maintainer
      @maintainer = Maintainer.find_by!(login: params[:login].downcase).decorate
   end

   def fetch_maintainer_bugs
      @all_bugs = BugDecorator.decorate_collection(Issue::Bug.for_maintainer_and_branch(@maintainer, @branch))
      @opened_bugs =  BugDecorator.decorate_collection(@all_bugs.object.opened)
   end
end
