class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :criteria, :criteria_type, :type
  end
end
