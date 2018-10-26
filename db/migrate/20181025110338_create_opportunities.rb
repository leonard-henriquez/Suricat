class CreateOpportunities < ActiveRecord::Migration[5.2]
  def change
    create_table :opportunities do |t|
      t.references :job, foreign_key: true
      t.references :company, foreign_key: true
      t.references :sector, foreign_key: true
      t.integer :salary
      t.string :job_description
      t.integer :contract_type
      t.string :location
      t.date :deadline
      t.date :start_date
      t.string :url
      t.date :publishing_date

      t.timestamps
    end
  end
end
