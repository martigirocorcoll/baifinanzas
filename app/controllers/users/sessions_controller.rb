# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # Auto-enable "remember me" for Turbo Native so sessions persist across app launches
  def create
    if turbo_native_app?
      params[:user] ||= {}
      params[:user][:remember_me] = "1"
    end
    super
  end
end
