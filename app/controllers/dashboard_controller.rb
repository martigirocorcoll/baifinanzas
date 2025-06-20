class DashboardController < ApplicationController
  def index
    @pyg     = current_user.pyg     || current_user.build_pyg
    @balance = current_user.balance || current_user.build_balance
    @objectives = current_user.objectives.order(:target_date)
  end
end
