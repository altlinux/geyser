# frozen_string_literal: true

module Api
  class BranchesController < BaseController
    private

    def resource
      @branch ||= Branch.find(params[:id])
    end

    def collection
      @branches ||= Branch.all
    end
  end
end
