class AddYoutubePlaylistIdToInfluencers < ActiveRecord::Migration[7.2]
  def change
    add_column :influencers, :youtube_playlist_id, :string
  end
end
