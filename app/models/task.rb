class Task < ApplicationRecord
   belongs_to :owner, class_name: 'Maintainer', foreign_key: :owner_slug, primary_key: :login
   belongs_to :branch_path

   has_one :branch, through: :branch_path

   has_many :exercises, dependent: :delete_all

   validates_presence_of :no, :state, :changed_at, :uri

   class << self
      def changed_at
         self.select("max(#{table_name}.changed_at) as changed_at")[0].read_attribute(:changed_at)
      end
   end
end
