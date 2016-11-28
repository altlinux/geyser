class CreateObsoletes < ActiveRecord::Migration[4.2]
  def change
    create_table :obsoletes do |t|
      t.integer :package_id
      t.string :name
      t.string :type
      t.string :version
      t.string :release

      t.timestamps
    end
  end
end
