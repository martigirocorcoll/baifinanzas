class ApplicationController < ActionController::Base
  around_action :switch_locale
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :track_referral

  # Include locale in all generated URLs
  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def switch_locale(&action)
    locale = extract_locale || I18n.default_locale
    session[:locale] = locale
    I18n.with_locale(locale, &action)
  end

  def extract_locale
    # Priority: URL param > session > browser Accept-Language > default
    parsed_locale = params[:locale] ||
                    session[:locale] ||
                    extract_locale_from_accept_language_header

    I18n.available_locales.map(&:to_s).include?(parsed_locale.to_s) ? parsed_locale.to_sym : nil
  end

  def extract_locale_from_accept_language_header
    return nil unless request.env['HTTP_ACCEPT_LANGUAGE']
    accepted = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/[a-z]{2}/).first
    I18n.available_locales.map(&:to_s).include?(accepted) ? accepted : nil
  end

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
