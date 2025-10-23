class AddDefaultToInfluencers < ActiveRecord::Migration[7.2]
  def change
    add_column :influencers, :default, :boolean, default: false, null: false
    add_index :influencers, :default
  end
end
