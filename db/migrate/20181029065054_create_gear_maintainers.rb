class CreateGearMaintainers < ActiveRecord::Migration[5.2]
  def change
    create_table :gear_maintainers do |t|
      t.references :gear, foreign_key: { on_delete: :cascade }
      t.references :maintainer, foreign_key: { on_delete: :cascade }

      t.timestamps

      t.index %w(gear_id maintainer_id), unique: true
    end
  end
end
