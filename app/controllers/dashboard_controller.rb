class DashboardController < ApplicationController
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
      redirect_to dashboard_index_path, alert: "Parámetros inválidos" and return
    end

    # Toggle: marcar o desmarcar según el estado actual
    if action_type == 'recommendation'
      if current_user.completed_recommendations.include?(action_key)
        current_user.uncomplete_recommendation!(action_key)
        flash[:success] = "Acción desmarcada"
      else
        current_user.complete_recommendation!(action_key)
        flash[:success] = "¡Acción completada! Sigue así 🎉"
      end
    elsif action_type == 'objective'
      if current_user.completed_objectives.include?(action_key.to_i)
        current_user.uncomplete_objective!(action_key)
        flash[:success] = "Objetivo desmarcado"
      else
        current_user.complete_objective!(action_key)
        flash[:success] = "¡Objetivo completado! 🎯"
      end
    end

    # Redirigir de vuelta al dashboard
    redirect_to dashboard_index_path
  end

  # Desmarcar una acción/recomendación como completada
  def uncomplete_action
    action_type = params[:action_type]
    action_key = params[:action_key]

    if action_type.blank? || action_key.blank?
      redirect_to dashboard_index_path, alert: "Parámetros inválidos" and return
    end

    # Desmarcar
    if action_type == 'recommendation'
      current_user.uncomplete_recommendation!(action_key)
      flash[:success] = "Acción desmarcada"
    elsif action_type == 'objective'
      current_user.uncomplete_objective!(action_key)
      flash[:success] = "Objetivo desmarcado"
    end

    redirect_to dashboard_index_path
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
    state = @financial_health_level
    case state
    when "Situación Crítica"
      {
        icon: "🔴",
        bootstrap_icon: "bi bi-exclamation-circle",
        name: "Situación Crítica",
        level_number: 1,
        description: "Actualmente tus gastos igualan o superan tus ingresos, lo que significa que no tienes capacidad de ahorro consistente. Esta situación es más común de lo que piensas y es el primer paso para tomar control de tus finanzas. Cada pequeña mejora en tus hábitos financieros te acercará al siguiente nivel.",
        next_step: "Tu prioridad es crear un flujo de caja positivo reduciendo gastos o aumentando ingresos. Revisa tus recomendaciones personalizadas para encontrar las mejores oportunidades de ahorro."
      }
    when "Creando Fondo de Emergencia"
      {
        icon: "🟡",
        bootstrap_icon: "bi bi-shield-plus",
        name: "Creando Fondo de Emergencia",
        level_number: 2,
        description: "¡Excelente progreso! Has logrado tener capacidad de ahorro mensual consistente. Tus ingresos superan tus gastos y puedes destinar dinero cada mes para mejorar tu situación. Ahora necesitas crear un colchón de seguridad que te proteja ante imprevistos.",
        next_step: "Construye tu fondo de emergencia de al menos 4 meses de gastos. Este colchón te dará tranquilidad para tomar mejores decisiones financieras."
      }
    when "Eliminando Deudas Caras"
      {
        icon: "🟠",
        bootstrap_icon: "bi bi-credit-card-2-back",
        name: "Eliminando Deudas Caras",
        level_number: 3,
        description: "Tienes capacidad de ahorro y un colchón de emergencia básico, lo cual demuestra disciplina. Sin embargo, las deudas caras (tarjetas de crédito, préstamos personales) están limitando tu potencial de crecimiento. Esta es la fase más desafiante pero también la más transformadora.",
        next_step: "Elimina o reduce significativamente tus deudas caras. Prioriza pagar las deudas con mayor interés primero. Cada euro que destines es una inversión con retorno garantizado."
      }
    when "Situación Estable"
      {
        icon: "🟢",
        bootstrap_icon: "bi bi-check-circle",
        name: "Situación Estable",
        level_number: 4,
        description: "¡Enhorabuena! Has alcanzado estabilidad financiera que solo el 15% de la población logra. Tienes capacidad de ahorro consistente, un fondo de emergencia sólido y tus deudas están bajo control. Desde aquí puedes planificar objetivos financieros específicos como una casa, inversiones o proyectos personales.",
        next_step: "Ahora puedes enfocarte en hacer crecer tu patrimonio. Define objetivos financieros específicos y comienza a invertir de forma inteligente."
      }
    when "Crecimiento Patrimonial"
      {
        icon: "💎",
        bootstrap_icon: "bi bi-gem",
        name: "Crecimiento Patrimonial",
        level_number: 5,
        description: "¡Extraordinario logro! Te encuentras en el 5% superior de la población. Has acumulado un patrimonio neto equivalente a al menos 2 años de ingresos, mantienes tus deudas bajo control y tienes sólida capacidad de ahorro e inversión. Puedes considerar estrategias más sofisticadas de inversión y optimización fiscal.",
        next_step: "Tu objetivo final está al alcance: lograr que tus inversiones generen ingresos pasivos superiores a tus gastos mensuales. Optimiza tu cartera y considera estrategias avanzadas."
      }
    when "Libertad Financiera"
      {
        icon: "👑",
        bootstrap_icon: "bi bi-trophy-fill",
        name: "Libertad Financiera",
        level_number: 6,
        description: "¡Felicidades por este logro excepcional! Has alcanzado la verdadera libertad financiera, un estatus que menos del 2% de la población logra. Tus inversiones generan ingresos pasivos suficientes para cubrir todos tus gastos mensuales. Puedes elegir cómo invertir tu tiempo basándote en tus pasiones, no en necesidades económicas.",
        next_step: "Enfócate en optimizar y preservar tu patrimonio, mientras exploras oportunidades de inversión especializadas o proyectos de impacto social."
      }
    else
      {
        icon: "❓",
        bootstrap_icon: "bi bi-question-circle",
        name: "Estado Desconocido",
        level_number: 0,
        description: "No hemos podido determinar tu estado financiero actual. Para ofrecerte el análisis más preciso necesitamos una visión completa de tu situación financiera.",
        next_step: "Completa toda la información en tu perfil financiero para obtener tu análisis detallado."
      }
    end
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
    states = [
      { name: "Situación Crítica", icon: "🔴", bootstrap_icon: "bi bi-exclamation-circle", level: 1 },
      { name: "Creando Fondo de Emergencia", icon: "🟡", bootstrap_icon: "bi bi-shield-plus", level: 2 },
      { name: "Eliminando Deudas Caras", icon: "🟠", bootstrap_icon: "bi bi-credit-card-2-back", level: 3 },
      { name: "Situación Estable", icon: "🟢", bootstrap_icon: "bi bi-check-circle", level: 4 },
      { name: "Crecimiento Patrimonial", icon: "💎", bootstrap_icon: "bi bi-gem", level: 5 },
      { name: "Libertad Financiera", icon: "👑", bootstrap_icon: "bi bi-trophy-fill", level: 6 }
    ]

    current_level_number = current_user.financial_health_level_number

    states.map do |state|
      {
        name: state[:name],
        icon: state[:icon],
        bootstrap_icon: state[:bootstrap_icon],
        level: state[:level],
        status: if state[:level] < current_level_number
                  "completed"
                elsif state[:level] == current_level_number
                  "current"
                else
                  "pending"
                end
      }
    end
  end

  def calculate_next_level_progress
    case @financial_health_level
    when "Situación Crítica"
      target = "Creando Fondo de Emergencia"
      requirements = [
        { name: "Flujo positivo", current: @monthly_cash_flow, target: 1, completed: @monthly_cash_flow > 0 }
      ]
    when "Creando Fondo de Emergencia"
      target = "Eliminando Deudas Caras"
      emergency_needed = current_user.monthly_expenses * 2
      current_emergency = current_user.liquid_assets
      requirements = [
        { name: "Colchón 2 meses", current: current_emergency, target: emergency_needed, completed: current_user.has_partial_emergency_fund? }
      ]
    when "Eliminando Deudas Caras"
      target = "Situación Estable"
      current_ratio = current_user.expensive_debt_ratio
      requirements = [
        { name: "Deuda cara < 40% patrimonio", current: (current_ratio * 100).round(1), target: 40, completed: current_ratio < 0.4 }
      ]
    when "Situación Estable"
      target = "Crecimiento Patrimonial"
      target_net_worth = current_user.annual_income * 2
      requirements = [
        { name: "Patrimonio ≥ 2 años ingresos", current: @net_worth, target: target_net_worth, completed: @net_worth >= target_net_worth }
      ]
    when "Crecimiento Patrimonial"
      target = "Libertad Financiera"
      investment_income = current_user.investment_income_monthly
      requirements = [
        { name: "Ingresos inversión ≥ gastos", current: investment_income, target: current_user.monthly_expenses, completed: current_user.has_financial_freedom? }
      ]
    else
      target = nil
      requirements = []
    end

    { target: target, requirements: requirements }
  end

  def financial_health_allows_objectives?
    ["Situación Estable", "Crecimiento Patrimonial", "Libertad Financiera"].include?(@financial_health_level)
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
    case recommendation_slug
    when "better_bank_account"
      {
        title: "Optimiza tu Cuenta Bancaria",
        description: "Elimina comisiones innecesarias y ahorra hasta 200€/año",
        cta: "Comparar Cuentas",
        icon: "bi-bank"
      }
    when "emergency_deposit"
      {
        title: "Construye tu Fondo de Emergencia",
        description: "Protégete ante imprevistos con un colchón financiero seguro",
        cta: "Ver Depósitos",
        icon: "bi-shield-check"
      }
    when "saving_advice"
      {
        title: "Consejos para Ahorrar Más",
        description: "Estrategias personalizadas para crear capacidad de ahorro",
        cta: "Ver Consejos",
        icon: "bi-piggy-bank"
      }
    when "debt_review"
      {
        title: "Optimiza tus Deudas",
        description: "Reduce intereses y acelera la cancelación de tus deudas",
        cta: "Revisar Deudas",
        icon: "bi-credit-card"
      }
    when "debt_optimization"
      {
        title: "Estrategia Anti-Deudas",
        description: "Plan integral para liberarte de deudas caras rápidamente",
        cta: "Ver Estrategia",
        icon: "bi-arrow-down-circle"
      }
    when "mortgage_optimization"
      {
        title: "Optimiza tu Hipoteca",
        description: "Reduce el coste de tu hipoteca y ahorra miles de euros",
        cta: "Optimizar Hipoteca",
        icon: "bi-house"
      }
    when "portfolio_optimization"
      {
        title: "Optimiza tus Inversiones",
        description: "Maximiza la rentabilidad de tu cartera de inversiones",
        cta: "Optimizar Cartera",
        icon: "bi-graph-up"
      }
    when "tax_advisory"
      {
        title: "Asesoramiento Fiscal",
        description: "Optimiza tu fiscalidad y planifica tu patrimonio",
        cta: "Contactar Asesor",
        icon: "bi-calculator"
      }
    else
      {
        title: recommendation_slug.humanize,
        description: "Recomendación personalizada para tu situación",
        cta: "Ver Detalles",
        icon: "bi-info-circle"
      }
    end
  end
end
