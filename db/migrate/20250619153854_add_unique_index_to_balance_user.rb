class AddUniqueIndexToBalanceUser < ActiveRecord::Migration[7.2]
  def change
    remove_index :balances, :user_id if index_exists?(:balances, :user_id)
    add_index :balances, :user_id, unique: true
  end
end
