class InfluencersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :edit, :update]
  before_action :set_influencer, only: %i[ show edit update destroy toggle_default ]
  before_action :authenticate_influencer_or_admin!, only: [:show, :edit, :update]
  before_action :require_admin!, only: [:index, :new, :create, :destroy, :toggle_default]

  # GET /influencers or /influencers.json
  def index
    @influencers = Influencer.all
  end

  # GET /influencers/1 or /influencers/1.json
  def show
    # Generate short referral link (discrete tracking)
    base_url = "#{request.protocol}#{request.host_with_port}"
    @referral_link = "#{base_url}/?ref=#{@influencer.code}"

    # Count referred users
    @referred_users_count = @influencer.users.count
  end

  # GET /influencers/new
  def new
    @influencer = Influencer.new
  end

  # GET /influencers/1/edit
  def edit
  end

  # POST /influencers or /influencers.json
  def create
    @influencer = Influencer.new(influencer_params)

    respond_to do |format|
      if @influencer.save
        format.html { redirect_to @influencer, notice: "Influencer was successfully created." }
        format.json { render :show, status: :created, location: @influencer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @influencer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /influencers/1 or /influencers/1.json
  def update
    respond_to do |format|
      if @influencer.update(influencer_params)
        format.html { redirect_to @influencer, notice: "Enlaces y videos actualizados correctamente." }
        format.json { render :show, status: :ok, location: @influencer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @influencer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /influencers/1 or /influencers/1.json
  def destroy
    @influencer.destroy!

    respond_to do |format|
      format.html { redirect_to influencers_path, status: :see_other, notice: "Influencer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # POST /influencers/1/toggle_default
  def toggle_default
    if @influencer.default?
      @influencer.remove_default!
      redirect_to influencers_path, notice: "#{@influencer.name} ya no es el influencer por defecto."
    else
      @influencer.set_as_default!
      redirect_to influencers_path, notice: "#{@influencer.name} establecido como influencer por defecto."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_influencer
      @influencer = Influencer.find(params[:id])

      # Security: Influencer can only access their own profile (unless user is admin)
      if current_influencer && !current_user&.admin?
        unless @influencer.id == current_influencer.id
          redirect_to influencer_path(current_influencer), alert: "No tienes permisos para acceder a este perfil."
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def influencer_params
      if action_name == 'create'
        # Admin creating new influencer: allow name, email, password
        params.require(:influencer).permit(:name, :email, :password, :password_confirmation)
      else
        # Influencer editing their own data: allow affiliate links and videos
        params.require(:influencer).permit(
          :name, :ac_compte, :ac_cdiposit, :ac_curt, :ac_llarg, :ac_deute, :ac_jubil, :ac_fiscal,
          :video_compte, :video_cdiposit, :video_curt, :video_llarg, :video_deute, :video_jubil, :video_fiscal, :video_portfolio
        )
      end
    end

    # Require admin access for management actions
    def require_admin!
      unless current_user&.admin?
        redirect_to root_path, alert: "No tienes permisos para acceder a esta página."
      end
    end

    # Allow access if user is admin OR if it's an authenticated influencer
    def authenticate_influencer_or_admin!
      unless current_user&.admin? || current_influencer
        redirect_to root_path, alert: "No tienes permisos para acceder a esta página."
      end
    end
end
