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
    when "Valle Profundo"
      {
        icon: "🏔️",
        bootstrap_icon: "bi bi-geo-alt",
        name: "Valle Profundo",
        description: "Te encuentras en el punto de partida de tu escalada financiera. En este momento, tus gastos igualan o superan tus ingresos, lo que significa que no tienes capacidad de ahorro consistente. Esta situación es muy común y es el primer paso para tomar control de tus finanzas. Desde aquí, cada pequeña mejora en tus hábitos financieros te acercará al siguiente nivel. No te preocupes, muchas personas exitosas financieramente han comenzado exactamente donde estás ahora.",
        next_step: "Tu prioridad es crear un flujo de caja positivo reduciendo gastos o aumentando ingresos. Revisa tus recomendaciones personalizadas para encontrar las mejores oportunidades de ahorro y productos que te ayuden a optimizar tus finanzas."
      }
    when "Campo Base"
      {
        icon: "🏕️",
        bootstrap_icon: "bi bi-house",
        name: "Campo Base", 
        description: "¡Excelente progreso! Has logrado algo fundamental: tener capacidad de ahorro mensual consistente. Esto significa que tus ingresos superan tus gastos y puedes destinar dinero cada mes para mejorar tu situación financiera. Estás en el 30% de españoles que logran ahorrar regularmente. Sin embargo, aún no tienes un colchón de seguridad que te proteja ante imprevistos. Tu siguiente objetivo es crear estabilidad financiera para poder avanzar con confianza hacia objetivos más ambiciosos.",
        next_step: "Es momento de construir tu fondo de emergencia de al menos 2 meses de gastos. Este colchón te dará la tranquilidad necesaria para tomar mejores decisiones financieras. Consulta tus recomendaciones personalizadas para encontrar las mejores cuentas de ahorro y productos de emergencia."
      }
    when "Pared Vertical"
      {
        icon: "🧗‍♂️",
        bootstrap_icon: "bi bi-arrow-up-circle",
        name: "Pared Vertical",
        description: "Te encuentras en la etapa más desafiante pero también más transformadora de tu escalada financiera. Tienes capacidad de ahorro y un colchón de emergencia básico, lo cual demuestra disciplina y progreso real. Sin embargo, las deudas caras (tarjetas de crédito, préstamos personales) están limitando tu potencial de crecimiento. Esta fase requiere estrategia, disciplina y a menudo sacrificios temporales, pero es donde realmente se forja la libertad financiera. Cada euro que destines a reducir deuda cara es una inversión con retorno garantizado equivalente al interés que dejas de pagar.",
        next_step: "Tu misión es eliminar o reducir significativamente tus deudas caras. Prioriza pagar las deudas con mayor interés primero. Tus recomendaciones personalizadas incluyen estrategias de consolidación de deuda y productos específicos para optimizar este proceso."
      }
    when "Cresta Estable"
      {
        icon: "🏔️",
        bootstrap_icon: "bi bi-graph-up",
        name: "Cresta Estable",
        description: "¡Enhorabuena! Has alcanzado un nivel de estabilidad financiera que solo el 15% de la población logra mantener. Tienes capacidad de ahorro consistente, un fondo de emergencia sólido y tus deudas están bajo control. Desde esta posición privilegiada, puedes permitirte pensar en grande y planificar objetivos financieros específicos como la compra de una casa, inversiones o proyectos personales. Tu base financiera es lo suficientemente sólida como para asumir riesgos calculados y aprovechar oportunidades de crecimiento. Es el momento perfecto para que tu dinero trabaje para ti.",
        next_step: "Ahora puedes enfocarte en hacer crecer tu patrimonio. Define objetivos financieros específicos y comienza a invertir de forma inteligente. Revisa tus recomendaciones personalizadas para encontrar las mejores opciones de inversión y productos que aceleren tu crecimiento patrimonial."
      }
    when "Alta Montaña"
      {
        icon: "⛰️",
        bootstrap_icon: "bi bi-award",
        name: "Alta Montaña",
        description: "¡Extraordinario logro! Te encuentras en el 5% superior de la población en términos de salud financiera. Has acumulado un patrimonio neto equivalente a al menos 2 años de tus ingresos, mantienes tus deudas bajo control y tienes una sólida capacidad de ahorro e inversión. Desde esta privilegiada posición, puedes permitirte una perspectiva financiera a largo plazo y considerar estrategias más sofisticadas de inversión y optimización fiscal. Tu situación te permite tomar decisiones basadas en oportunidades rather than necesidades, y tienes la libertad de explorar proyectos que combinen rentabilidad con propósito personal.",
        next_step: "Tu objetivo final está al alcance: lograr que tus inversiones generen ingresos pasivos superiores a tus gastos mensuales. Optimiza tu cartera de inversiones y considera estrategias avanzadas. Tus recomendaciones personalizadas incluyen productos de inversión premium y asesoramiento especializado para este nivel patrimonial."
      }
    when "Cima Conquistada"
      {
        icon: "🏔️👑",
        bootstrap_icon: "bi bi-trophy",
        name: "Cima Conquistada",
        description: "¡Felicidades por este logro excepcional! Has alcanzado la verdadera libertad financiera, un estatus que menos del 2% de la población logra. Tus inversiones y activos generan ingresos pasivos suficientes para cubrir todos tus gastos mensuales sin necesidad de trabajar. Esta independencia financiera te otorga la libertad más valiosa: la capacidad de elegir cómo invertir tu tiempo basándote en tus pasiones y valores, no en necesidades económicas. Desde esta cumbre, puedes dedicarte a proyectos que generen impacto, ayudar a otros en su escalada financiera, o simplemente disfrutar de la tranquilidad que proporciona la seguridad económica absoluta.",
        next_step: "Con la libertad financiera conquistada, puedes enfocarte en optimizar y preservar tu patrimonio, mientras exploras oportunidades de inversión más especializadas o proyectos de impacto social. Tus recomendaciones personalizadas incluyen estrategias de preservación patrimonial y oportunidades filantrópicas."
      }
    else
      {
        icon: "❓",
        bootstrap_icon: "bi bi-question-circle",
        name: "Estado Desconocido",
        description: "No hemos podido determinar tu estado financiero actual. Esto puede ocurrir cuando faltan datos importantes en tu perfil financiero o cuando hay inconsistencias en la información proporcionada. Para ofrecerte el análisis más preciso y recomendaciones personalizadas, necesitamos tener una visión completa de tu situación financiera incluyendo ingresos, gastos, activos y deudas.",
        next_step: "Completa toda la información en tu perfil financiero para obtener tu análisis detallado. Una vez completado, podrás acceder a tus recomendaciones personalizadas diseñadas específicamente para tu situación."
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
      { name: "Valle Profundo", icon: "🏔️", bootstrap_icon: "bi bi-geo-alt", level: 0 },
      { name: "Campo Base", icon: "🏕️", bootstrap_icon: "bi bi-house", level: 1 },
      { name: "Pared Vertical", icon: "🧗‍♂️", bootstrap_icon: "bi bi-arrow-up-circle", level: 2 },
      { name: "Cresta Estable", icon: "🏔️", bootstrap_icon: "bi bi-graph-up", level: 3 },
      { name: "Alta Montaña", icon: "⛰️", bootstrap_icon: "bi bi-award", level: 4 },
      { name: "Cima Conquistada", icon: "🏔️👑", bootstrap_icon: "bi bi-trophy", level: 5 }
    ]
    
    current_level = case @financial_health_level
                   when "Valle Profundo" then 0
                   when "Campo Base" then 1
                   when "Pared Vertical" then 2
                   when "Cresta Estable" then 3
                   when "Alta Montaña" then 4
                   when "Cima Conquistada" then 5
                   else 0
                   end
    
    states.map.with_index do |state, index|
      {
        name: state[:name],
        icon: state[:icon],
        bootstrap_icon: state[:bootstrap_icon],
        level: state[:level],
        status: if index < current_level
                  "completed"
                elsif index == current_level
                  "current"
                else
                  "pending"
                end
      }
    end
  end

  def calculate_next_level_progress
    case @financial_health_level
    when "Valle Profundo"
      target = "Campo Base"
      requirements = [
        { name: "Flujo positivo", current: @monthly_cash_flow, target: 1, completed: @monthly_cash_flow > 0 }
      ]
    when "Campo Base"
      target = "Pared Vertical"
      emergency_needed = current_user.monthly_expenses * 2
      current_emergency = current_user.liquid_assets
      requirements = [
        { name: "Colchón 2 meses", current: current_emergency, target: emergency_needed, completed: current_user.has_partial_emergency_fund? }
      ]
    when "Pared Vertical"
      target = "Cresta Estable"
      current_ratio = current_user.expensive_debt_ratio
      requirements = [
        { name: "Deuda cara < 40% patrimonio", current: (current_ratio * 100).round(1), target: 40, completed: current_ratio < 0.4 }
      ]
    when "Cresta Estable"
      target = "Alta Montaña"
      target_net_worth = current_user.annual_income * 2
      requirements = [
        { name: "Patrimonio ≥ 2 años ingresos", current: @net_worth, target: target_net_worth, completed: @net_worth >= target_net_worth }
      ]
    when "Alta Montaña"
      target = "Cima Conquistada"
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
    ["Cresta Estable", "Alta Montaña", "Cima Conquistada"].include?(@financial_health_level)
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
