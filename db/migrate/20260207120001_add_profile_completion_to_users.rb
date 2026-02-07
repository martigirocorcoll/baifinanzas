class AddProfileCompletionToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :pyg_completed, :boolean, default: false, null: false
    add_column :users, :balance_completed, :boolean, default: false, null: false
  end
end
