class ChangeColumnDateTime < ActiveRecord::Migration[5.2]
  def change
    change_column :events, :date, :datetime
    rename_column :events, :date, :start_time
  end
end
