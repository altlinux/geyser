class AddSrpmIdToAclModel < ActiveRecord::Migration[4.2]
  def change
    add_column :acls, :srpm_id, :integer
    add_index :acls, :srpm_id
    remove_index :acls, :package
    remove_column :acls, :package, :string
  end
end
