class CreatePerlWatches < ActiveRecord::Migration[4.2]
  def change
    create_table :perl_watches do |t|
      t.string :name
      t.string :version
      t.string :path

      t.timestamps
    end
  end
end
