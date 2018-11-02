# frozen_string_literal: true

class RsyncController < ApplicationController
  def new
    @branch = Branch.find_by!(slug: 'sisyphus')
    @groups = @branch.groups.root.order('slug')
  end
end
