class CreateImportances < ActiveRecord::Migration[5.2]
  def change
    create_table :importances do |t|
      t.references :user, foreign_key: true
      t.integer :type
      t.integer :value

      t.timestamps
    end
  end
end
