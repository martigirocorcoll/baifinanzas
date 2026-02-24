namespace :youtube do
  desc "Sync latest YouTube videos for all influencers with a channel"
  task sync: :environment do
    SyncYoutubeVideosJob.perform_now
  end
end
