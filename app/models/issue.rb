# frozen_string_literal: true

class Issue < ApplicationRecord
   validates :no, presence: true
end
