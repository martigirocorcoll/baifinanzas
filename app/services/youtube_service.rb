require "net/http"
require "json"
require "uri"

class YoutubeService
  BASE_URL = "https://www.googleapis.com/youtube/v3"

  def initialize(api_key = ENV['YOUTUBE_API_KEY'])
    @api_key = api_key
  end

  def available?
    @api_key.present?
  end

  def latest_videos(channel_id, max_results: 10)
    return [] unless available? && channel_id.present?

    fetch_videos(channel_id, max_results)
  end

  def playlist_videos(playlist_id, max_results: 50)
    return [] unless available? && playlist_id.present?

    fetch_playlist_videos(playlist_id, max_results)
  end

  # Extract playlist ID from a YouTube playlist URL or raw ID
  def self.extract_playlist_id(input)
    return nil unless input.present?

    input = input.strip

    # Already a playlist ID (starts with PL)
    return input if input.match?(/\APL[\w-]+\z/)

    # Extract from URL: youtube.com/playlist?list=PLxxxx
    if input.match?(/[?&]list=(PL[\w-]+)/)
      return input[/[?&]list=(PL[\w-]+)/, 1]
    end

    nil
  end

  # Resolve a YouTube URL or handle to a channel ID
  # Accepts: @handle, youtube.com/@handle, youtube.com/channel/UCxxx
  def resolve_channel_id(input)
    return nil unless available? && input.present?

    input = input.strip

    # Already a channel ID (starts with UC)
    return input if input.match?(/\AUC[\w-]{22}\z/)

    # Extract handle from URL: youtube.com/@handle
    if input.match?(%r{youtube\.com/@})
      handle = input[%r{youtube\.com/@([\w.-]+)}, 1]
    elsif input.start_with?("@")
      handle = input.delete_prefix("@")
    end

    # Extract channel ID from URL: youtube.com/channel/UCxxx
    if input.match?(%r{youtube\.com/channel/(UC[\w-]{22})})
      return input[%r{youtube\.com/channel/(UC[\w-]{22})}, 1]
    end

    return nil unless handle.present?

    # Call YouTube API to resolve handle -> channel ID
    resolve_handle(handle)
  end

  private

  def fetch_playlist_videos(playlist_id, max_results)
    data = api_get("/playlistItems", part: "snippet", playlistId: playlist_id, maxResults: [max_results, 50].min)
    return [] unless data

    items = data["items"] || []
    video_ids = items.filter_map { |item| item.dig("snippet", "resourceId", "videoId") }

    # Fetch real publish dates from /videos endpoint
    real_dates = fetch_video_publish_dates(video_ids)

    items.map do |item|
      snippet = item["snippet"]
      video_id = snippet.dig("resourceId", "videoId")
      next unless video_id

      {
        id: video_id,
        title: snippet["title"],
        thumbnail: snippet.dig("thumbnails", "high", "url") || snippet.dig("thumbnails", "medium", "url") || snippet.dig("thumbnails", "default", "url"),
        published_at: real_dates[video_id] || Time.parse(snippet["publishedAt"]),
        url: "https://www.youtube.com/watch?v=#{video_id}",
        embed_url: "https://www.youtube.com/embed/#{video_id}",
        channel_title: snippet["videoOwnerChannelTitle"],
        duration_seconds: 0
      }
    end.compact
  rescue StandardError => e
    Rails.logger.error("YoutubeService playlist error: #{e.message}")
    []
  end

  def fetch_video_publish_dates(video_ids)
    return {} if video_ids.empty?

    data = api_get("/videos", part: "snippet", id: video_ids.join(","))
    return {} unless data

    (data["items"] || []).each_with_object({}) do |item, hash|
      hash[item["id"]] = Time.parse(item.dig("snippet", "publishedAt"))
    end
  rescue StandardError => e
    Rails.logger.error("YoutubeService publish dates error: #{e.message}")
    {}
  end

  def resolve_handle(handle)
    data = api_get("/channels", part: "id", forHandle: "@#{handle}")
    data&.dig("items", 0, "id")
  rescue StandardError => e
    Rails.logger.error("YoutubeService resolve_handle error: #{e.message}")
    nil
  end

  def fetch_videos(channel_id, max_results)
    # Fetch extra results to compensate for Shorts we'll filter out
    data = api_get("/search", part: "snippet", channelId: channel_id, order: "date", type: "video", maxResults: [max_results * 3, 50].min)
    return [] unless data

    items = data["items"] || []

    # First pass: filter out obvious Shorts by title
    items = items.reject { |item| short_by_title?(item.dig("snippet", "title")) }

    # Second pass: check actual duration via Videos API to filter remaining Shorts (<= 60s)
    video_ids = items.map { |item| item.dig("id", "videoId") }.compact
    durations = fetch_video_durations(video_ids) if video_ids.any?
    durations ||= {}

    items.select { |item|
      vid = item.dig("id", "videoId")
      dur = durations[vid]
      dur.nil? || dur > 60 # keep if duration unknown or > 60 seconds
    }.first(max_results).map do |item|
      snippet = item["snippet"]
      video_id = item.dig("id", "videoId")
      {
        id: video_id,
        title: snippet["title"],
        thumbnail: snippet.dig("thumbnails", "high", "url") || snippet.dig("thumbnails", "medium", "url") || snippet.dig("thumbnails", "default", "url"),
        published_at: Time.parse(snippet["publishedAt"]),
        url: "https://www.youtube.com/watch?v=#{video_id}",
        embed_url: "https://www.youtube.com/embed/#{video_id}",
        channel_title: snippet["channelTitle"],
        duration_seconds: durations[video_id] || 0
      }
    end
  rescue StandardError => e
    Rails.logger.error("YoutubeService error: #{e.message}")
    []
  end

  def short_by_title?(title)
    return false unless title
    title.match?(/\#shorts?\b/i)
  end

  def fetch_video_durations(video_ids)
    return {} if video_ids.empty?

    data = api_get("/videos", part: "contentDetails", id: video_ids.join(","))
    return {} unless data

    (data["items"] || []).each_with_object({}) do |item, hash|
      hash[item["id"]] = parse_iso8601_duration(item.dig("contentDetails", "duration"))
    end
  rescue StandardError => e
    Rails.logger.error("YoutubeService duration check error: #{e.message}")
    {}
  end

  # Parse ISO 8601 duration (PT1M30S, PT5S, PT1H2M3S) to seconds
  def parse_iso8601_duration(duration)
    return 0 unless duration
    match = duration.match(/PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/)
    return 0 unless match
    (match[1].to_i * 3600) + (match[2].to_i * 60) + match[3].to_i
  end

  def api_get(path, **params)
    uri = URI("#{BASE_URL}#{path}")
    uri.query = URI.encode_www_form(params.merge(key: @api_key))

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(Net::HTTP::Get.new(uri))

    return nil unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end
end
