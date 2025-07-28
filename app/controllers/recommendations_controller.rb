class RecommendationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recommendation
  
  def show
    @objective = params[:objetivo_id].present? ? current_user.objectives.find(params[:objetivo_id]) : nil
    @affiliate_link = current_user.get_affiliate_link(@recommendation.slug)
    
    # Contexto para personalizar el contenido
    @contextual_title = @recommendation.contextual_title(@objective)
    @contextual_description = @recommendation.contextual_description(@objective)
    
    # Datos para el gráfico de evolución si hay objetivo
    if @objective.present?
      @investment_evolution_data = prepare_investment_evolution_data
    end
  end
  
  private
  
  def set_recommendation
    @recommendation = Recommendation.active.find_by!(slug: params[:slug])
  rescue ActiveRecord::RecordNotFound
    redirect_to dashboard_index_path, alert: "Recomendación no encontrada"
  end
  
  def prepare_investment_evolution_data
    return {} unless @objective.present?
    
    monthly_savings = @objective.monthly_savings_needed
    total_months = @objective.months_to_target
    annual_return = @objective.expected_return
    monthly_return = annual_return / 12.0
    
    # Calcular evolución mes a mes
    labels = []
    invested_amounts = []
    final_values = []
    
    (0..total_months).each do |month|
      if month == 0
        labels << "Inicio"
        invested_amounts << 0
        final_values << 0
      else
        labels << "Mes #{month}"
        
        # Cantidad total invertida hasta este mes
        total_invested = monthly_savings * month
        invested_amounts << total_invested
        
        # Valor final con interés compuesto
        final_value = 0
        (1..month).each do |m|
          periods_remaining = month - m + 1
          final_value += monthly_savings * ((1 + monthly_return) ** (periods_remaining - 1))
        end
        final_values << final_value.round(2)
      end
    end
    
    total_invested = monthly_savings * total_months
    total_benefit = final_values.last - total_invested
    
    {
      labels: labels,
      invested_amounts: invested_amounts,
      final_values: final_values,
      monthly_savings: monthly_savings,
      total_months: total_months,
      total_invested: total_invested,
      total_benefit: total_benefit,
      annual_return: (annual_return * 100).round(1)
    }
  end
end
