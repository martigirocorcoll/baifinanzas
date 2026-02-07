class DiscoveryController < ApplicationController
  layout 'app'

  def index
    @influencer = current_user.influencer || Influencer.find_by(default: true) || Influencer.first

    # Load content for the feed
    @videos = load_influencer_videos
    @articles = load_articles
    @news = load_app_news

    # Merge and sort all content by date (most recent first)
    @feed_items = build_feed_items
  end

  def show_article
    @article = Article.published.find_by(slug: params[:slug])
    redirect_to discovery_path unless @article
  end

  private

  def load_influencer_videos
    return [] unless @influencer.present?

    videos = []

    video_fields = [
      { key: 'video_compte', type: 'ac_compte' },
      { key: 'video_cdiposit', type: 'ac_cdiposit' },
      { key: 'video_curt', type: 'ac_curt' },
      { key: 'video_llarg', type: 'ac_llarg' },
      { key: 'video_deute', type: 'ac_deute' },
      { key: 'video_jubil', type: 'ac_jubil' },
      { key: 'video_fiscal', type: 'ac_fiscal' },
      { key: 'video_portfolio', type: 'ac_portfolio' }
    ]

    video_fields.each do |field|
      url = @influencer.send(field[:key])
      if url.present?
        videos << {
          type: 'video',
          url: url,
          title: video_title_for(field[:type]),
          influencer_name: @influencer.name || @influencer.email,
          published_at: @influencer.updated_at
        }
      end
    end

    videos
  end

  def load_articles
    Article.published.map do |article|
      {
        type: 'article',
        id: article.id,
        slug: article.slug,
        title: article.title,
        excerpt: article.excerpt,
        body: article.body,
        author: article.author,
        read_time: article.read_time,
        category: article.category,
        published_at: article.published_at
      }
    end
  end

  def load_app_news
    AppNews.published.map do |news|
      {
        type: 'news',
        id: news.id,
        title: news.title,
        content: news.content,
        published_at: news.published_at
      }
    end
  end

  def build_feed_items
    # Articles + news mixed by date, videos always at the end
    content = (@articles + @news).sort_by { |item| item[:published_at] }.reverse
    videos = @videos.sort_by { |v| v[:published_at] }.reverse
    content + videos
  end

  def video_title_for(video_type)
    case video_type
    when 'ac_compte'
      t('discovery.video_titles.bank_account', default: 'Mejores cuentas bancarias')
    when 'ac_cdiposit'
      t('discovery.video_titles.deposits', default: 'Depositos a plazo fijo')
    when 'ac_curt'
      t('discovery.video_titles.short_term', default: 'Inversiones a corto plazo')
    when 'ac_llarg'
      t('discovery.video_titles.long_term', default: 'Invertir a largo plazo')
    when 'ac_deute'
      t('discovery.video_titles.debt', default: 'Gestion de deudas')
    when 'ac_jubil'
      t('discovery.video_titles.retirement', default: 'Planificar la jubilacion')
    when 'ac_fiscal'
      t('discovery.video_titles.taxes', default: 'Optimizacion fiscal')
    when 'ac_portfolio'
      t('discovery.video_titles.portfolio', default: 'Gestion de cartera')
    else
      t('discovery.video_titles.default', default: 'Consejos financieros')
    end
  end
end
