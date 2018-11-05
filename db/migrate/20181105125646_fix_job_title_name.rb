class FixJobTitleName < ActiveRecord::Migration[5.2]
  def change
    rename_column :jobs, :title, :name
  end
end
