class Exercise < ApplicationRecord
   belongs_to :task
   belongs_to :committer, class_name: 'Maintainer', primary_key: :login, foreign_key: :committer_slug

   has_one :tag, primary_key: :sha, foreign_key: :sha

   has_many :repos, primary_key: :resource, foreign_key: :uri
   has_many :packages, primary_key: :pkgname, foreign_key: :name
   has_many :exercise_approvers
   has_many :approvers, through: :exercise_approvers

   scope :repo, -> { where(kind: 'repo') }

   delegate :name, to: :tag, prefix: :tag

   validates_presence_of :no, :kind, :pkgname
   validates_presence_of :resource, if: -> { kind =~ /repo|srpm/ }
   validates_presence_of :sha, if: -> { kind =~ /repo/ }
end
