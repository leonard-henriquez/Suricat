class CreateCriteria < ActiveRecord::Migration[5.2]
  def change
    create_table :criteria do |t|
      t.references :importance, foreign_key: true
      t.string :value
      t.integer :rank

      t.timestamps
    end
  end
end
