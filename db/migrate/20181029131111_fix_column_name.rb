class FixColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :importances, :type, :name
  end
end
