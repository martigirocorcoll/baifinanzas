class Influencer < ApplicationRecord
  # Owner: the User account that manages this influencer profile
  belongs_to :user, optional: true

  # Referred users: users who signed up with this influencer's code
  has_many :users

  # YouTube videos synced from their playlist
  has_many :youtube_videos, dependent: :destroy

  # Virtual attributes: influencer pastes their YouTube URLs
  attr_accessor :youtube_url, :youtube_playlist_url

  # Validations
  validates :name, presence: true

  # Callbacks
  after_create :generate_unique_code
  before_validation :resolve_youtube_url, if: -> { youtube_url.present? }
  before_validation :resolve_youtube_playlist_url, if: -> { youtube_playlist_url.present? }
  after_save :sync_youtube_videos, if: -> { saved_change_to_youtube_playlist_id? && youtube_playlist_id.present? }

  # Class method to get default influencer
  def self.default_influencer
    find_by(default: true)
  end

  # Instance method to set this influencer as default
  def set_as_default!
    Influencer.where(default: true).update_all(default: false)
    update!(default: true)
  end

  # Instance method to remove default status
  def remove_default!
    update!(default: false)
  end

  private

  def generate_unique_code
    return if code.present?
    self.code = SecureRandom.hex(4)
    save if changed?
  end

  def sync_youtube_videos
    SyncYoutubeVideosJob.perform_later(id)
  end

  def resolve_youtube_url
    service = YoutubeService.new
    return unless service.available?

    channel_id = service.resolve_channel_id(youtube_url)
    if channel_id.present?
      self.youtube_channel_id = channel_id
    elsif youtube_channel_id.present? && youtube_url.include?(youtube_channel_id)
      # Already resolved, no change needed
    else
      errors.add(:youtube_url, "no se ha podido encontrar el canal de YouTube")
    end
  end

  def resolve_youtube_playlist_url
    playlist_id = YoutubeService.extract_playlist_id(youtube_playlist_url)
    if playlist_id.present?
      self.youtube_playlist_id = playlist_id
    else
      errors.add(:youtube_playlist_url, "no se ha podido extraer el ID de la playlist")
    end
  end
end
