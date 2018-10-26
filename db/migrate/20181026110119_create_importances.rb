class CreateImportances < ActiveRecord::Migration[5.2]
  def change
    create_table :importances do |t|
      t.integer :value
      t.references :criterium, foreign_key: true

      t.timestamps
    end
  end
end
