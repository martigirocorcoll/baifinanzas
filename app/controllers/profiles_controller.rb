class ProfilesController < ApplicationController
  layout 'app'

  def show
    @user = current_user
    @financial_level_key = current_user.financial_health_level_key
    @financial_level_number = current_user.financial_health_level_number
    @profile_complete = current_user.profile_complete?
    @member_since = current_user.created_at

    # Financial summary data
    @income = current_user.monthly_income
    @expenses = current_user.monthly_expenses
    @cash_flow = current_user.monthly_cash_flow
    @total_assets = current_user.total_assets
    @total_debts = current_user.total_debt
    @net_worth = current_user.net_worth

    # For chart bar widths
    @max_income_expense = [@income, @expenses].max
    @max_asset_debt = [@total_assets, @total_debts].max
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
end
