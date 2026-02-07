class Article < ApplicationRecord
  validates :slug, presence: true, uniqueness: { case_sensitive: false }
  validates :title, presence: true

  scope :published, -> { where(active: true).where("published_at <= ?", Time.current).order(published_at: :desc) }
  scope :by_category, ->(cat) { where(category: cat) if cat.present? }

  def to_param
    slug
  end
end
