class CreateChangelogs < ActiveRecord::Migration[4.2]
  def change
    create_table :changelogs do |t|
      t.integer :srpm_id
      t.string :changelogtime
      t.binary :changelogname
      t.binary :changelogtext

      t.timestamps
    end

    add_index :changelogs, :srpm_id
  end
end
