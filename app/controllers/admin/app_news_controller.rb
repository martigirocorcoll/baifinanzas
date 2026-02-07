module Admin
  class AppNewsController < BaseController
    before_action :set_news, only: [:edit, :update, :destroy]

    def index
      @news = AppNews.order(created_at: :desc)
    end

    def new
      @news_item = AppNews.new(published_at: Time.current)
    end

    def create
      @news_item = AppNews.new(news_params)
      if @news_item.save
        redirect_to admin_app_news_index_path, notice: "Noticia creada correctamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @news_item.update(news_params)
        redirect_to admin_app_news_index_path, notice: "Noticia actualizada correctamente."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @news_item.destroy!
      redirect_to admin_app_news_index_path, notice: "Noticia eliminada.", status: :see_other
    end

    private

    def set_news
      @news_item = AppNews.find(params[:id])
    end

    def news_params
      params.require(:app_news).permit(:title, :content, :published_at, :active)
    end
  end
end
