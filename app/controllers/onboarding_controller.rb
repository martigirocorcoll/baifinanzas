class OnboardingController < ApplicationController
  def welcome
    # Check onboarding status and redirect if necessary
    pyg = current_user.pyg
    balance = current_user.balance

    if pyg&.has_data? && balance&.has_data?
      # User has completed onboarding, redirect to dashboard
      redirect_to authenticated_root_path, notice: "¡Bienvenido de nuevo! Tu plan está listo."
    elsif pyg&.has_data? && balance.present? && !balance.has_data?
      # User has PyG data but not Balance, redirect to create Balance
      redirect_to new_balance_path, notice: "¡Excelente! Solo falta completar tu balance patrimonial."
    end
    # Otherwise, show welcome page (user has no data yet)
  end

  def processing
    # Loading screen that shows for 5 seconds before redirecting to dashboard
    # Auto-redirects via JavaScript after animation completes
  end
end
