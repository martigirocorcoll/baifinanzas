class AppNews < ApplicationRecord
  self.table_name = "app_news"

  validates :title, presence: true

  scope :published, -> { where(active: true).where("published_at <= ?", Time.current).order(published_at: :desc) }
end
