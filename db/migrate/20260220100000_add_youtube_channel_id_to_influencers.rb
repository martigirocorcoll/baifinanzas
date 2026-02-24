class AddYoutubeChannelIdToInfluencers < ActiveRecord::Migration[7.2]
  def change
    add_column :influencers, :youtube_channel_id, :string
  end
end
