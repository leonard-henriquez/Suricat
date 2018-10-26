class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.date :date
      t.string :name

      t.timestamps
    end
  end
end
