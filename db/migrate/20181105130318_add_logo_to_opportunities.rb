class AddLogoToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :logo, :string
  end
end
