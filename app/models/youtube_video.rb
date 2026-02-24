class YoutubeVideo < ApplicationRecord
  belongs_to :influencer

  validates :youtube_video_id, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true

  scope :active, -> { where(active: true) }
  scope :recent, -> { order(published_at: :desc) }
  scope :for_influencer, ->(inf) { where(influencer: inf) }

  def url
    "https://www.youtube.com/watch?v=#{youtube_video_id}"
  end

  def embed_url
    "https://www.youtube.com/embed/#{youtube_video_id}"
  end
end
