module Admin
  class ArticlesController < BaseController
    before_action :set_article, only: [:show, :edit, :update, :destroy]

    def index
      @articles = Article.order(created_at: :desc)
    end

    def show
    end

    def new
      @article = Article.new(published_at: Time.current)
    end

    def create
      @article = Article.new(article_params)
      if @article.save
        redirect_to admin_articles_path, notice: "Articulo creado correctamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @article.update(article_params)
        redirect_to admin_articles_path, notice: "Articulo actualizado correctamente."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @article.destroy!
      redirect_to admin_articles_path, notice: "Articulo eliminado.", status: :see_other
    end

    private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:slug, :title, :excerpt, :body, :category, :read_time, :author, :published_at, :active)
    end
  end
end
