class CreateYoutubeVideos < ActiveRecord::Migration[7.2]
  def change
    create_table :youtube_videos do |t|
      t.string :youtube_video_id, null: false
      t.references :influencer, null: false, foreign_key: true
      t.string :title, null: false
      t.string :thumbnail_url
      t.string :channel_title
      t.integer :duration_seconds, default: 0
      t.datetime :published_at
      t.boolean :active, default: true, null: false

      t.timestamps
    end
    add_index :youtube_videos, :youtube_video_id, unique: true
    add_index :youtube_videos, [:influencer_id, :published_at]
  end
end
