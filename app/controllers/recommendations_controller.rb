class RecommendationsController < ApplicationController
  layout 'app'
  before_action :authenticate_user!
  before_action :set_recommendation, only: [:show]

  def index
    @recommendations = Recommendation.active.order(:title)
  end

  def show
    @objective = params[:objetivo_id].present? ? current_user.objectives.find(params[:objetivo_id]) : nil
    @affiliate_link = current_user.get_affiliate_link(@recommendation.slug.underscore.gsub('-', '_'))

    # Contexto para personalizar el contenido
    @contextual_title = @recommendation.contextual_title(@objective)
    @contextual_description = @recommendation.contextual_description(@objective)

    # Datos para el gráfico de evolución si hay objetivo
    if @objective.present?
      @investment_evolution_data = prepare_investment_evolution_data
    end

    # Preparar datos del simulador (con valores del objetivo o por defecto)
    @simulator_data = prepare_simulator_data
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

  def prepare_simulator_data
    if @objective.present?
      # Datos del objetivo
      monthly = @objective.monthly_savings_needed.round(0)
      years = (@objective.months_to_target / 12.0).ceil
      annual_return = (@objective.expected_return * 100).round(1)
      target_amount = @objective.target_amount.round(0)
      objective_name = @objective.title

      {
        has_objective: true,
        objective_name: objective_name,
        target_amount: target_amount,
        initial_contribution: 0,
        monthly_contribution: monthly,
        years: years,
        annual_return: annual_return
      }
    else
      # Valores por defecto según el tipo de recomendación
      case @recommendation.slug
      when "ac-llarg"
        {
          has_objective: false,
          initial_contribution: 0,
          monthly_contribution: 300,
          years: 10,
          annual_return: 8.0
        }
      when "ac-jubil"
        {
          has_objective: false,
          initial_contribution: 0,
          monthly_contribution: 200,
          years: 30,
          annual_return: 8.0
        }
      when "ac-curt"
        {
          has_objective: false,
          initial_contribution: 0,
          monthly_contribution: 400,
          years: 3,
          annual_return: 3.0
        }
      when "ac-diposit"
        {
          has_objective: false,
          initial_contribution: 5000,
          monthly_contribution: 200,
          years: 2,
          annual_return: 1.5
        }
      else
        {
          has_objective: false,
          initial_contribution: 0,
          monthly_contribution: 200,
          years: 10,
          annual_return: 5.0
        }
      end
    end
  end
end
