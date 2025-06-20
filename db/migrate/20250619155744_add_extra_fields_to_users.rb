class AddExtraFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :phone, :string
    add_column :users, :country, :string
    add_column :users, :risk_profile, :integer
    add_reference :users, :influencer, foreign_key: true
    add_reference :users, :pyg, foreign_key: true
    add_reference :users, :balance, foreign_key: true

    remove_index :users, :pyg_id   if index_exists?(:users, :pyg_id)
    remove_index :users, :balance_id if index_exists?(:users, :balance_id)
    add_index    :users, :pyg_id,    unique: true
    add_index    :users, :balance_id, unique: true
  end
end
