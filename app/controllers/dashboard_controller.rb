class DashboardController < ApplicationController
  layout 'app'
  def index
    @pyg = current_user.pyg || current_user.build_pyg
    @balance = current_user.balance || current_user.build_balance
    @objectives = current_user.objectives.order(:target_date)
    
    # Determinar el estado del usuario
    @user_state = determine_user_state
    
    # Cargar datos según el estado
    case @user_state
    when :new_user
      # Estado 1: Solo bienvenida y formulario P&L
      load_new_user_data
    when :has_pyg
      # Estado 2: Datos P&L + gráfico + ranking + formulario Balance
      load_pyg_data
    when :complete
      # Estado 3: Análisis completo + salud financiera + objetivos
      load_complete_data
    end
  end

  # Marcar/desmarcar una acción/recomendación (toggle)
  def complete_action
    action_type = params[:action_type] # 'recommendation' or 'objective'
    action_key = params[:action_key]   # rec_key o objective_id

    if action_type.blank? || action_key.blank?
      redirect_back fallback_location: home_path, alert: t('flash.invalid_params') and return
    end

    # Toggle: marcar o desmarcar según el estado actual
    if action_type == 'recommendation'
      if current_user.completed_recommendations.include?(action_key)
        current_user.uncomplete_recommendation!(action_key)
        flash[:success] = t('flash.action_unmarked')
      else
        current_user.complete_recommendation!(action_key)
        flash[:success] = t('flash.action_completed')
      end
    elsif action_type == 'objective'
      if current_user.completed_objectives.include?(action_key.to_i)
        current_user.uncomplete_objective!(action_key)
        flash[:success] = t('flash.objective_unmarked')
      else
        current_user.complete_objective!(action_key)
        flash[:success] = t('flash.objective_completed')
      end
    end

    redirect_back fallback_location: home_path
  end

  # Desmarcar una acción/recomendación como completada
  def uncomplete_action
    action_type = params[:action_type]
    action_key = params[:action_key]

    if action_type.blank? || action_key.blank?
      redirect_back fallback_location: home_path, alert: t('flash.invalid_params') and return
    end

    # Desmarcar
    if action_type == 'recommendation'
      current_user.uncomplete_recommendation!(action_key)
      flash[:success] = t('flash.action_unmarked')
    elsif action_type == 'objective'
      current_user.uncomplete_objective!(action_key)
      flash[:success] = t('flash.objective_unmarked')
    end

    redirect_back fallback_location: home_path
  end

  private
  
  def determine_user_state
    # Verificar si los registros tienen datos reales (no solo registros vacíos)
    pyg_has_data = @pyg.persisted? && @pyg.ingresos_mensual.present? && @pyg.ingresos_mensual > 0
    balance_has_data = @balance.persisted? && has_balance_data?
    
    if !pyg_has_data
      :new_user
    elsif pyg_has_data && !balance_has_data
      :has_pyg
    else
      :complete
    end
  end
  
  def load_new_user_data
    # Para el formulario P&L embebido
    @pyg = current_user.build_pyg if @pyg.new_record?
  end
  
  def load_pyg_data
    # Datos calculados del P&L
    @monthly_cash_flow = current_user.monthly_cash_flow
    @monthly_income = current_user.monthly_income
    @monthly_expenses = current_user.monthly_expenses
    
    # Comparación con media española
    @spain_comparison = calculate_spain_comparison
    
    # Datos para el gráfico cascada
    @income_data = prepare_income_data
    @expense_data = prepare_expense_data
    
    # Para el formulario Balance embebido
    @balance = current_user.build_balance if @balance.new_record?
  end
  
  def load_complete_data
    # Datos financieros completos
    @financial_health_level = current_user.financial_health_level
    @monthly_cash_flow = current_user.monthly_cash_flow
    @net_worth = current_user.net_worth
    @has_emergency_fund = current_user.has_emergency_fund?
    
    # Estado de montaña con explicación
    @mountain_state = get_mountain_state_info
    
    # Progreso de escalada completo
    @mountain_progress = calculate_mountain_progress
    
    # Recomendaciones completas: base (sin duplicar objetivos) + objetivos
    base_recs = current_user.base_financial_recommendations
    objective_recs = current_user.can_invest_in_objectives? ? current_user.objective_recommendations : []
    
    # Excluir de base_recs las que ya están en objective_recs para evitar duplicados
    filtered_base_recs = base_recs - objective_recs
    all_recommendation_types = filtered_base_recs
    
    # Debug: verificar todas las recomendaciones
    Rails.logger.debug "=== DEBUG RECOMENDACIONES ==="
    Rails.logger.debug "Financial health level: #{current_user.financial_health_level}"
    Rails.logger.debug "Base recommendations: #{base_recs}"
    Rails.logger.debug "Objective recommendations: #{objective_recs}"
    Rails.logger.debug "All recommendation types: #{all_recommendation_types}"
    Rails.logger.debug "User has influencer: #{current_user.influencer.present?}"
    
    @all_recommendations = all_recommendation_types.map do |recommendation|
      affiliate_link = current_user.get_affiliate_link(recommendation)
      Rails.logger.debug "#{recommendation} -> #{affiliate_link || 'NO LINK'}"
      
      rec_info = get_recommendation_info(recommendation)
      {
        product: recommendation,
        title: rec_info[:title],
        description: rec_info[:description],
        cta: rec_info[:cta],
        icon: rec_info[:icon],
        affiliate_link: affiliate_link
      }
    end
    
    Rails.logger.debug "Final recommendations count: #{@all_recommendations.count}"
    
    # Progreso hacia siguiente nivel
    @next_level_progress = calculate_next_level_progress
    
    # Datos para gráficos PyG y Balance
    @pyg_chart_data = prepare_pyg_chart_data
    @balance_chart_data = prepare_balance_chart_data
    
    # Objetivos válidos para mostrar con sus recomendaciones
    @active_objectives = current_user.objectives.select(&:valid_for_display?)
    @objectives_with_recommendations = @active_objectives.map do |objective|
      {
        objective: objective,
        recommendation_type: objective.investment_recommendation,
        affiliate_link: current_user.get_affiliate_link(objective.investment_recommendation),
        monthly_needed: objective.monthly_savings_needed
      }
    end
    @new_objective = current_user.objectives.build

    # Action Plan - Plan de acción unificado
    @action_plan = current_user.action_plan
    @current_task = current_user.current_task
    @completed_count = @action_plan.count { |a| a[:completed] }
    @total_count = @action_plan.count
    @progress_percentage = @total_count > 0 ? ((@completed_count.to_f / @total_count) * 100).round(0) : 0

    # Datos de capacidad de ahorro (para HIGH levels)
    @monthly_cash_flow_data = {
      theoretical: @monthly_cash_flow,
      committed: @active_objectives.sum { |obj| obj.monthly_savings_needed },
      available: @monthly_cash_flow - @active_objectives.sum { |obj| obj.monthly_savings_needed }
    }
  end
  
  def calculate_spain_comparison
    return {} unless @pyg.persisted?
    
    # Datos estimados de España 2024
    spain_median_income = 2100  # Salario mediano España
    spain_median_savings_rate = 0.12  # 12% de ahorro promedio
    spain_median_savings = spain_median_income * spain_median_savings_rate
    
    income_diff = ((@monthly_income.to_f / spain_median_income - 1) * 100).round(1)
    savings_diff = if @monthly_cash_flow > 0 && spain_median_savings > 0
                     ((@monthly_cash_flow.to_f / spain_median_savings - 1) * 100).round(1)
                   else
                     nil
                   end
    
    {
      spain_median_income: spain_median_income,
      spain_median_savings: spain_median_savings.round(0),
      income_diff: income_diff,
      savings_diff: savings_diff,
      income_comparison: income_diff > 0 ? "superior" : "inferior",
      savings_comparison: savings_diff && savings_diff > 0 ? "superior" : "inferior"
    }
  end
  
  def get_basic_recommendations
    [
      "Abre una cuenta de ahorro con interés",
      "Construye un fondo de emergencia",
      "Considera un depósito a plazo fijo"
    ]
  end
  
  def prepare_income_data
    return {} unless @pyg.persisted?
    
    {
      ingresos_mensual: @pyg.ingresos_mensual || 0
    }
  end
  
  def prepare_expense_data
    return {} unless @pyg.persisted?
    
    {
      vivienda: @pyg.alquiler_hipoteca || 0,
      utilities: @pyg.gastos_utilities || 0,
      alimentacion: @pyg.gasto_compra || 0,
      transporte: @pyg.gastos_transporte || 0,
      ocio: @pyg.restaurantes_y_ocio || 0,
      seguros: @pyg.gastos_seguros || 0,
      cuota_hipoteca: @pyg.cuota_hipoteca || 0,
      cuota_coche: @pyg.cuota_coche || 0,
      otras_cuotas: @pyg.otras_cuotas || 0,
      suscripciones: @pyg.suscripciones || 0,
      cuidado_personal: @pyg.cuidado_personal || 0,
      otros: @pyg.otros_gastos || 0
    }
  end
  
  def prepare_balance_data
    return {} unless @balance.persisted?
    
    {
      assets: {
        inmuebles: @balance.valor_inmuebles || 0,
        cuentas: @balance.dinero_cuenta_corriente || 0,
        ahorros: @balance.dinero_cuenta_ahorro_depos || 0,
        inversiones: @balance.dinero_inversiones_f || 0,
        pensiones: @balance.dinero_planes_pensiones || 0,
        vehiculos: @balance.valor_coches_vehiculos || 0,
        otros: @balance.valor_otros_activos || 0
      },
      debts: {
        hipoteca: @balance.hipoteca_inmuebles || 0,
        tarjetas: @balance.deuda_tarjeta_credito || 0,
        prestamos: @balance.prestamos_personales || 0,
        coches: @balance.prestamos_coches || 0,
        otras: @balance.otras_deudas || 0
      }
    }
  end
  
  def get_mountain_state_info
    level_key = current_user.financial_health_level_key

    {
      icon: t("financial.levels.#{level_key}.icon"),
      bootstrap_icon: t("financial.levels.#{level_key}.bootstrap_icon"),
      name: t("financial.levels.#{level_key}.name"),
      level_number: current_user.financial_health_level_number,
      description: t("financial.levels.#{level_key}.description"),
      next_step: t("financial.levels.#{level_key}.next_step")
    }
  end

  def prepare_pyg_chart_data
    return {} unless @pyg.persisted?
    
    total_income = @pyg.ingresos_mensual || 0
    total_expenses = current_user.monthly_expenses
    cash_flow = total_income - total_expenses
    
    {
      income: total_income,
      expenses: total_expenses,
      cash_flow: cash_flow
    }
  end

  def prepare_balance_chart_data
    return {} unless @balance.persisted?
    
    total_assets = current_user.total_assets
    total_debt = current_user.total_debt
    net_worth = total_assets - total_debt
    
    {
      assets: total_assets,
      debt: total_debt,
      net_worth: net_worth
    }
  end

  def calculate_mountain_progress
    level_keys = [:critical, :emergency_fund, :paying_debt, :stable, :growth, :financial_freedom]
    current_level_number = current_user.financial_health_level_number

    level_keys.each_with_index.map do |level_key, index|
      level_number = index + 1
      {
        name: t("financial.levels.#{level_key}.name"),
        icon: t("financial.levels.#{level_key}.icon"),
        bootstrap_icon: t("financial.levels.#{level_key}.bootstrap_icon"),
        level: level_number,
        status: if level_number < current_level_number
                  "completed"
                elsif level_number == current_level_number
                  "current"
                else
                  "pending"
                end
      }
    end
  end

  def calculate_next_level_progress
    level_key = current_user.financial_health_level_key

    case level_key
    when :critical
      target = t('financial.levels.emergency_fund.name')
      requirements = [
        { name: t('financial.next_level.positive_cash_flow'), current: @monthly_cash_flow, target: 1, completed: @monthly_cash_flow > 0 }
      ]
    when :emergency_fund
      target = t('financial.levels.paying_debt.name')
      emergency_needed = current_user.monthly_expenses * 2
      current_emergency = current_user.liquid_assets
      requirements = [
        { name: t('financial.next_level.emergency_2_months'), current: current_emergency, target: emergency_needed, completed: current_user.has_partial_emergency_fund? }
      ]
    when :paying_debt
      target = t('financial.levels.stable.name')
      current_ratio = current_user.expensive_debt_ratio
      requirements = [
        { name: t('financial.next_level.expensive_debt_under_40'), current: (current_ratio * 100).round(1), target: 40, completed: current_ratio < 0.4 }
      ]
    when :stable
      target = t('financial.levels.growth.name')
      target_net_worth = current_user.annual_income * 2
      requirements = [
        { name: t('financial.next_level.net_worth_2_years'), current: @net_worth, target: target_net_worth, completed: @net_worth >= target_net_worth }
      ]
    when :growth
      target = t('financial.levels.financial_freedom.name')
      investment_income = current_user.investment_income_monthly
      requirements = [
        { name: t('financial.next_level.investment_income_covers_expenses'), current: investment_income, target: current_user.monthly_expenses, completed: current_user.has_financial_freedom? }
      ]
    else
      target = nil
      requirements = []
    end

    { target: target, requirements: requirements }
  end

  def financial_health_allows_objectives?
    [:stable, :growth, :financial_freedom].include?(current_user.financial_health_level_key)
  end
  
  def prepare_objectives_with_recommendations
    @objectives.map do |objective|
      {
        objective: objective,
        recommendation: current_user.recommendations_with_links.find { |r| r[:type] == objective.investment_recommendation },
        monthly_needed: objective.monthly_savings_needed,
        can_afford: @monthly_cash_flow >= objective.monthly_savings_needed
      }
    end
  end
  
  def has_balance_data?
    return false unless @balance.persisted?
    
    # Verificar si tiene al menos un activo o deuda con valor
    total_assets = (@balance.valor_inmuebles || 0) + 
                   (@balance.dinero_cuenta_corriente || 0) + 
                   (@balance.dinero_cuenta_ahorro_depos || 0) +
                   (@balance.dinero_inversiones_f || 0) + 
                   (@balance.dinero_planes_pensiones || 0) +
                   (@balance.valor_coches_vehiculos || 0) +
                   (@balance.valor_otros_activos || 0)
    
    total_debts = (@balance.hipoteca_inmuebles || 0) + 
                  (@balance.deuda_tarjeta_credito || 0) + 
                  (@balance.prestamos_personales || 0) +
                  (@balance.prestamos_coches || 0) +
                  (@balance.otras_deudas || 0)
    
    total_assets > 0 || total_debts > 0
  end

  def get_recommendation_info(recommendation_slug)
    # Normalize key for lookup
    lookup_key = case recommendation_slug
    when 'debt_review' then 'debt_optimization'
    else recommendation_slug
    end

    {
      title: t("financial.recommendations.#{lookup_key}.description",
               default: t("financial.recommendations.default.description")),
      description: t("financial.recommendations.#{lookup_key}.benefit",
                     default: t("financial.recommendations.default.benefit")),
      cta: t("financial.recommendations.#{lookup_key}.cta",
             default: t("financial.recommendations.default.cta")),
      icon: t("financial.recommendations.#{lookup_key}.icon",
              default: "bi-info-circle")
    }
  end
end
