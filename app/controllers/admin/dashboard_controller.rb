module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_influencers = Influencer.count
      @total_articles = Article.count
      @total_news = AppNews.count

      # Users by financial level
      @level_distribution = User.includes(:pyg).where.not(pygs: { id: nil }).group_by { |u|
        u.financial_health_level_number
      }.transform_values(&:count)

      # Recent users (last 7 days)
      @recent_users = User.where("created_at >= ?", 7.days.ago).count

      # Top influencers by referrals
      @top_influencers = Influencer.left_joins(:users)
                                   .group("influencers.id")
                                   .select("influencers.*, COUNT(users.id) as users_count")
                                   .order("users_count DESC")
                                   .limit(5)
    end
  end
end
