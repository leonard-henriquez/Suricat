class CreateSectors < ActiveRecord::Migration[5.2]
  def change
    create_table :sectors do |t|
      t.string :name
      t.references :sector_category, foreign_key: true

      t.timestamps
    end
  end
end
