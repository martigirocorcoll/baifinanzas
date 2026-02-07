module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:show, :update]

    def index
      @users = User.includes(:influencer, :pyg).order(created_at: :desc)
    end

    def show
    end

    def update
      old_role = @user.role
      new_role = params[:user][:role]

      if @user.update(role: new_role)
        # If promoting to influencer, create Influencer profile if missing
        if new_role == "influencer" && @user.influencer_profile.nil?
          Influencer.create!(name: @user.email.split("@").first.capitalize, user: @user)
        end

        # If demoting from influencer, optionally keep or destroy profile
        # (we keep it for data preservation)

        redirect_to admin_user_path(@user), notice: "Rol actualizado de '#{old_role}' a '#{new_role}'."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_user
      @user = User.includes(:pyg, :balance, :objectives, :influencer, :influencer_profile).find(params[:id])
    end
  end
end
