class DropBranchFromSpecfile < ActiveRecord::Migration[4.2]
  def change
    remove_index :specfiles, :branch_id
    remove_column :specfiles, :branch_id
  end
end
