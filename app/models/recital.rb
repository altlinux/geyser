# frozen_string_literal: true

class Recital < ApplicationRecord
   belongs_to :maintainer

   accepts_nested_attributes_for :maintainer
end
