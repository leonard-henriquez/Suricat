class FixColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :criteria, :criteria_value, :value
  end
end
