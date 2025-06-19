class AddUniqueIndexToPygUser < ActiveRecord::Migration[7.2]
  def change
    remove_index :pygs, :user_id if index_exists?(:pygs, :user_id)
    add_index :pygs, :user_id, unique: true
  end
end
