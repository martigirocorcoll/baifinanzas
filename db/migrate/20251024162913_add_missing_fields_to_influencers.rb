class AddMissingFieldsToInfluencers < ActiveRecord::Migration[7.2]
  def change
    add_column :influencers, :ac_portfolio, :string
    add_column :influencers, :ac_saving, :string
    add_column :influencers, :ac_mortgage, :string
    add_column :influencers, :video_saving, :string
    add_column :influencers, :video_mortgage, :string
  end
end
