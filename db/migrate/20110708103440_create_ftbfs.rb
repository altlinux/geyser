class CreateFtbfs < ActiveRecord::Migration[4.2]
  def change
    create_table :ftbfs do |t|
      t.string :name
      t.string :epoch
      t.string :version
      t.string :release
      t.integer :weeks
      t.integer :branch_id

      t.timestamps
    end
  end
end
