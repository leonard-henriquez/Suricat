class CreateUserOpportunities < ActiveRecord::Migration[5.2]
  def change
    create_table :user_opportunities do |t|
      t.references :user, foreign_key: true
      t.references :opportunity, foreign_key: true
      t.integer :automatic_grade
      t.integer :personnal_grade
      t.integer :status

      t.timestamps
    end
  end
end
