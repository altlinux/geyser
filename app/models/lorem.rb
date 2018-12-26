class Lorem < ApplicationRecord
   belongs_to :package

   validates_presence_of :text, :codepage, :type
end
