class AddVideoDipositToInfluencers < ActiveRecord::Migration[7.2]
  def change
    add_column :influencers, :video_diposit, :string
  end
end
