# rubocop:disable Metrics/MethodLength
class CreateSrpms < ActiveRecord::Migration[4.2]
  def change
    create_table :srpms do |t|
      t.string :branch
      t.string :vendor
      t.string :filename
      t.string :name
      t.string :version
      t.string :release
      t.string :epoch
      t.string :summary
      t.string :license
      t.string :url
      t.text :description
      t.datetime :buildtime
      t.string :size

      t.timestamps
    end
  end
end
