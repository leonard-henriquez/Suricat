class AddIntroToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :intro, :boolean, default: false
  end
end
