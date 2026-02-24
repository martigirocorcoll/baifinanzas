class SyncYoutubeVideosJob < ApplicationJob
  queue_as :default

  def perform(influencer_id = nil)
    youtube = YoutubeService.new
    return unless youtube.available?

    influencers = if influencer_id
      Influencer.where(id: influencer_id).where.not(youtube_channel_id: [nil, ""])
    else
      Influencer.where.not(youtube_channel_id: [nil, ""])
    end

    influencers.find_each do |influencer|
      sync_for_influencer(youtube, influencer)
    end
  end

  private

  def sync_for_influencer(youtube, influencer)
    videos = youtube.latest_videos(influencer.youtube_channel_id, max_results: 20)

    videos.each do |video_data|
      record = YoutubeVideo.find_or_initialize_by(youtube_video_id: video_data[:id])
      record.assign_attributes(
        influencer: influencer,
        title: video_data[:title],
        thumbnail_url: video_data[:thumbnail],
        channel_title: video_data[:channel_title],
        duration_seconds: video_data[:duration_seconds] || 0,
        published_at: video_data[:published_at]
      )
      record.save! if record.new_record? || record.changed?
    end

    Rails.logger.info("SyncYoutubeVideosJob: synced #{videos.count} videos for #{influencer.name}")
  rescue StandardError => e
    Rails.logger.error("SyncYoutubeVideosJob error for #{influencer.name}: #{e.message}")
  end
end
