# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # Override create to assign influencer after user signup
  def create
    super do |resource|
      if resource.persisted?
        # Assign influencer from session/cookie if present
        influencer_code = session[:influencer_code] || cookies[:influencer_code]
        resource.assign_influencer_from_code(influencer_code) if influencer_code.present?
      end
    end
  end

  protected

  # Redirect to welcome page after signup (new account creation)
  def after_sign_up_path_for(resource)
    onboarding_welcome_path
  end
end
