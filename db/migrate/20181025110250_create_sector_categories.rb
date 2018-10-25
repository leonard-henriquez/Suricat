class CreateSectorCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :sector_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
