class RepoTag < ApplicationRecord
   belongs_to :repo
   belongs_to :tag
end
