class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :track_referral

  protected

  def configure_permitted_parameters
    keys = [:phone, :country, :risk_profile, :influencer_id]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(Influencer)
      influencer_path(resource)
    elsif resource.is_a?(User)
      # Check if user has financial data (using has_data? method)
      pyg_has_data = resource.pyg&.has_data?

      # If user has no data in PyG, they're new → go to welcome
      if !pyg_has_data
        onboarding_welcome_path
      else
        # Existing user with data logging in → go to dashboard
        authenticated_root_path
      end
    else
      authenticated_root_path
    end
  end

  def track_referral
    # Track influencer referral code via 'ref' parameter
    if params[:ref].present?
      # Store in session (survives page navigation)
      session[:influencer_code] = params[:ref]

      # Also store in cookie for 30 days (survives browser close)
      cookies[:influencer_code] = { value: params[:ref], expires: 30.days.from_now }
    end
  end
end
