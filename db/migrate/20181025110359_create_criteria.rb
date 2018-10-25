class CreateCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :criteria do |t|
      t.references :user, foreign_key: true
      t.integer :criteria_type
      t.string :criteria_value
      t.integer :rank
      t.integer :importance

      t.timestamps
    end
  end
end
