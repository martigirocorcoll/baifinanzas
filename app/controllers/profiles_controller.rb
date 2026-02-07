class ProfilesController < ApplicationController
  layout 'app'

  def show
    @user = current_user
    @financial_level = current_user.financial_health_level_number
    @financial_level_key = current_user.financial_health_level_key
    @has_pyg = current_user.pyg_completed?
    @has_balance = current_user.balance_completed?

    # Profile completion percentage
    @profile_completion = calculate_profile_completion

    # Stats for profile
    plan = current_user.action_plan.select { |a| a[:type] == 'recommendation' }
    @actions_completed = plan.count { |a| a[:completed] }
    @actions_total = plan.count
    @objectives_count = current_user.objectives.count
    @member_since = current_user.created_at
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to profile_path, notice: t('profile.updated_successfully', default: 'Profile updated successfully')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def settings
    @user = current_user
    @available_locales = I18n.available_locales
    @current_locale = I18n.locale
  end

  def update_settings
    @user = current_user

    if params[:new_locale].present? && I18n.available_locales.include?(params[:new_locale].to_sym)
      session[:locale] = params[:new_locale]
      redirect_to profile_settings_path(locale: params[:new_locale]), notice: t('profile.settings_updated', default: 'Settings updated', locale: params[:new_locale].to_sym)
    else
      redirect_to profile_settings_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def calculate_profile_completion
    completion = 0

    # Step 1: Basic user info (25%)
    completion += 25 if current_user.email.present?

    # Step 2: Detailed PyG (25%)
    completion += 25 if current_user.pyg_completed?

    # Step 3: Detailed Balance (25%)
    completion += 25 if current_user.balance_completed?

    # Step 4: At least one objective (25%)
    completion += 25 if current_user.objectives.any?

    completion
  end
end
