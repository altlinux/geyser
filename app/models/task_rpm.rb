class TaskRpm < ApplicationRecord
   belongs_to :task
   belongs_to :package, primary_key: :md5, foreign_key: :md5
end
