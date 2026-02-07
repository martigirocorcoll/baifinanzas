module Admin
  class InfluencersController < BaseController
    before_action :set_influencer, only: [:show, :edit, :update, :destroy, :toggle_default]

    def index
      @influencers = Influencer.all.order(:name)
    end

    def show
      @referred_users_count = @influencer.users.count
      @referred_users = @influencer.users.order(created_at: :desc).limit(10)
    end

    def new
      @influencer = Influencer.new
    end

    def create
      # Create User account with influencer role
      user = User.new(
        email: params[:influencer][:email],
        password: params[:influencer][:password],
        password_confirmation: params[:influencer][:password_confirmation],
        role: "influencer"
      )

      if user.save
        # Create Influencer profile linked to the User
        @influencer = Influencer.new(name: params[:influencer][:name], user: user)
        if @influencer.save
          redirect_to admin_influencers_path, notice: "Influencer '#{@influencer.name}' creado correctamente."
        else
          user.destroy
          render :new, status: :unprocessable_entity
        end
      else
        @influencer = Influencer.new(name: params[:influencer][:name])
        @influencer.errors.merge!(user.errors)
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @influencer.update(influencer_params)
        redirect_to admin_influencer_path(@influencer), notice: "Influencer actualizado correctamente."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      name = @influencer.name
      user = @influencer.user
      @influencer.destroy!
      user&.destroy if user&.influencer?
      redirect_to admin_influencers_path, notice: "Influencer '#{name}' eliminado.", status: :see_other
    end

    def toggle_default
      if @influencer.default?
        @influencer.remove_default!
        redirect_to admin_influencers_path, notice: "#{@influencer.name} ya no es el influencer por defecto."
      else
        @influencer.set_as_default!
        redirect_to admin_influencers_path, notice: "#{@influencer.name} establecido como influencer por defecto."
      end
    end

    private

    def set_influencer
      @influencer = Influencer.find(params[:id])
    end

    def influencer_params
      params.require(:influencer).permit(
        :name, :email, :password, :password_confirmation,
        :ac_compte, :ac_cdiposit, :ac_saving, :ac_deute, :ac_mortgage,
        :ac_curt, :ac_llarg, :ac_jubil, :ac_portfolio, :ac_fiscal,
        :video_compte, :video_cdiposit, :video_diposit, :video_saving, :video_deute, :video_mortgage,
        :video_curt, :video_llarg, :video_jubil, :video_portfolio, :video_fiscal
      )
    end
  end
end
