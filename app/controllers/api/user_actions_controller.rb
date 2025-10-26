class Api::UserActionsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def check
    rec_key = params[:recommendation]
    completed = current_user.completed_recommendations.include?(rec_key)

    render json: { completed: completed }
  end

  def complete
    rec_key = params[:recommendation]
    current_user.complete_recommendation!(rec_key)

    render json: { success: true, message: 'Recomendación marcada como completada' }
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  def uncomplete
    rec_key = params[:recommendation]
    current_user.uncomplete_recommendation!(rec_key)

    render json: { success: true, message: 'Recomendación desmarcada' }
  rescue => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end
end
