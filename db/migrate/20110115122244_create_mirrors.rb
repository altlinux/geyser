class CreateMirrors < ActiveRecord::Migration[4.2]
  def change
    create_table :mirrors do |t|
      t.integer :branch_id
      t.integer :order_id
      t.string :name
      t.string :country
      t.string :uri
      t.string :protocol

      t.timestamps
    end
  end
end
