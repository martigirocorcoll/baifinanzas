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
    @savings_ranking = calculate_savings_ranking
    @basic_recommendations = get_basic_recommendations
    
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
    
    # Progreso hacia siguiente nivel
    @next_level_progress = calculate_next_level_progress
    
    # Datos para gráficos
    @income_data = prepare_income_data
    @expense_data = prepare_expense_data
    @balance_data = prepare_balance_data
    
    # Objetivos con recomendaciones (solo si el nivel lo permite)
    if financial_health_allows_objectives?
      @objectives_with_recommendations = prepare_objectives_with_recommendations
    end
  end
  
  def calculate_savings_ranking
    return "Sin datos suficientes" unless @pyg.persisted?
    
    monthly_savings = current_user.monthly_cash_flow
    return "Flujo negativo" if monthly_savings <= 0
    
    # Simulamos rankings basados en el ahorro mensual
    case monthly_savings
    when 0..300
      "Top 70% de ahorradores"
    when 300..800
      "Top 40% de ahorradores"
    when 800..1500
      "Top 20% de ahorradores"
    else
      "Top 10% de ahorradores"
    end
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
  
  def calculate_next_level_progress
    case @financial_health_level
    when "Iniciando"
      target = "Construyendo Base"
      requirements = [
        { name: "Flujo positivo", current: @monthly_cash_flow, target: 1, completed: @monthly_cash_flow > 0 }
      ]
    when "Construyendo Base"
      target = "Liberándose de Deudas"
      emergency_needed = current_user.monthly_expenses * 3
      current_emergency = @balance&.dinero_cuenta_corriente || 0
      requirements = [
        { name: "Fondo de emergencia", current: current_emergency, target: emergency_needed, completed: current_user.has_emergency_fund? }
      ]
    when "Liberándose de Deudas"
      target = "Invirtiendo en Objetivos"
      total_debt = current_user.total_debt
      max_debt = [current_user.net_worth * 0.15, current_user.annual_income * 2].min
      requirements = [
        { name: "Reducir deuda", current: total_debt, target: max_debt, completed: total_debt <= max_debt }
      ]
    else
      target = nil
      requirements = []
    end
    
    { target: target, requirements: requirements }
  end
  
  def financial_health_allows_objectives?
    ["Invirtiendo en Objetivos", "Acomodado", "Libertad Financiera"].include?(@financial_health_level)
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
end
