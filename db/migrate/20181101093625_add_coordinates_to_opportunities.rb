class AddCoordinatesToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :latitude, :float
    add_column :opportunities, :longitude, :float
  end
end
