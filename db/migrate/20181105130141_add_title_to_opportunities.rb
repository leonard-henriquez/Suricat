class AddTitleToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :title, :string
  end
end
