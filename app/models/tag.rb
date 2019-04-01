class Tag < ApplicationRecord
   belongs_to :author, class_name: 'Maintainer'
   belongs_to :tagger, class_name: 'Maintainer'

   has_many :repo_tags
   has_many :repos, through: :repo_tags

   validates_presence_of :sha, :name, :authored_at, :tagged_at
end
