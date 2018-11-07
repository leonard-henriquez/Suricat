class AddEmailToOpportunities < ActiveRecord::Migration[5.2]
  def change
    add_column :opportunities, :email, :string
  end
end
