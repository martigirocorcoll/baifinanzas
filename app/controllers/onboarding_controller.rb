class OnboardingController < ApplicationController
  layout 'app'

  STEPS = %w[ingresos gastos ahorros inversiones inmuebles hipoteca deuda_cara riesgo].freeze
  TOTAL_STEPS = STEPS.length

  before_action :redirect_if_completed, only: [:welcome]

  def welcome
    session.delete(:onboarding)
  end

  # GET /onboarding/step/:step_name
  def step
    @step_name = params[:step_name]
    return redirect_to onboarding_welcome_path unless STEPS.include?(@step_name)

    @step_number = STEPS.index(@step_name) + 1
    @total_steps = TOTAL_STEPS
    @progress = ((@step_number.to_f / TOTAL_STEPS) * 100).round
    @from = params[:from] || session.dig(:onboarding, :from)

    # Pre-fill from session or existing DB data
    onboarding_data = session[:onboarding] || {}
    @value = onboarding_data[@step_name] || onboarding_data[@step_name.to_sym]
    @toggle = onboarding_data["#{@step_name}_toggle"] || onboarding_data[:"#{@step_name}_toggle"]

    # Pre-fill from DB if updating from profile and no session data yet
    if @from == 'profile' && @value.nil?
      prefill_from_db(@step_name)
    end

    render "onboarding/steps/#{@step_name}"
  end

  # POST /onboarding/step/:step_name
  def save_step
    @step_name = params[:step_name]
    return redirect_to onboarding_welcome_path unless STEPS.include?(@step_name)

    session[:onboarding] ||= {}
    session[:onboarding]["from"] = params[:from] if params[:from].present?

    # Save toggle and value to session (use string keys for JSON serialization)
    if params[:toggle].present?
      session[:onboarding]["#{@step_name}_toggle"] = params[:toggle]
    end

    if params[:value].present?
      session[:onboarding][@step_name] = params[:value].to_i
    elsif params[:toggle] == 'no'
      session[:onboarding][@step_name] = 0
    end

    # Validate: riesgo requires a selection
    if @step_name == 'riesgo' && params[:value].blank?
      flash[:alert] = t('onboarding.steps.riesgo.select_one', default: 'Selecciona un nivel de riesgo')
      return redirect_to onboarding_step_path(step_name: 'riesgo', from: session.dig(:onboarding, 'from'))
    end

    # Navigate to next step or save
    current_index = STEPS.index(@step_name)
    if current_index < STEPS.length - 1
      redirect_to onboarding_step_path(step_name: STEPS[current_index + 1], from: session[:onboarding][:from])
    else
      save_all_and_finish
    end
  end

  def processing
    @from = params[:from]
  end

  def complete
    @from = params[:from]
    @financial_level = {
      key: current_user.financial_health_level_key,
      number: current_user.financial_health_level_number,
      name: t("financial.levels.#{current_user.financial_health_level_key}.name"),
      icon: t("financial.levels.#{current_user.financial_health_level_key}.bootstrap_icon")
    }
  end

  private

  def redirect_if_completed
    if current_user.has_basic_financial_data? && params[:from].blank?
      redirect_to home_path
    end
  end

  def prefill_from_db(step_name)
    pyg = current_user.pyg
    balance = current_user.balance

    case step_name
    when 'ingresos'
      @value = pyg&.ingresos_mensual if pyg&.ingresos_mensual.to_i > 0
    when 'gastos'
      @value = current_user.monthly_expenses if current_user.monthly_expenses > 0
    when 'ahorros'
      if balance
        total = balance.dinero_cuenta_corriente + balance.dinero_cuenta_ahorro_depos
        @value = total if total > 0
      end
    when 'inversiones'
      if balance
        total = balance.dinero_inversiones_f + balance.dinero_planes_pensiones
        @value = total if total > 0
        @toggle = total > 0 ? 'yes' : 'no'
      end
    when 'inmuebles'
      if balance
        @value = balance.valor_inmuebles if balance.valor_inmuebles > 0
        @toggle = balance.valor_inmuebles > 0 ? 'yes' : 'no'
      end
    when 'hipoteca'
      if balance
        @value = balance.hipoteca_inmuebles if balance.hipoteca_inmuebles > 0
        @toggle = balance.hipoteca_inmuebles > 0 ? 'yes' : 'no'
      end
    when 'deuda_cara'
      if balance
        total = balance.deuda_tarjeta_credito + balance.prestamos_personales
        @value = total if total > 0
        @toggle = total > 0 ? 'yes' : 'no'
      end
    when 'riesgo'
      @value = current_user.risk_profile if current_user.risk_profile.present?
    end
  end

  def save_all_and_finish
    data = (session[:onboarding] || {}).with_indifferent_access
    from = data[:from]

    pyg = current_user.pyg || current_user.build_pyg
    balance = current_user.balance || current_user.build_balance

    # Income
    pyg.ingresos_mensual = data[:ingresos].to_i if data[:ingresos].present?

    # Expenses - distribute across categories (25/35/10/10/10/10)
    if data[:gastos].present?
      total_expenses = data[:gastos].to_i
      pyg.gasto_compra = (total_expenses * 0.25).round
      pyg.alquiler_hipoteca = (total_expenses * 0.35).round
      pyg.gastos_utilities = (total_expenses * 0.10).round
      pyg.gastos_transporte = (total_expenses * 0.10).round
      pyg.restaurantes_y_ocio = (total_expenses * 0.10).round
      pyg.otros_gastos = (total_expenses * 0.10).round
      pyg.gastos_seguros ||= 0
      pyg.cuota_hipoteca ||= 0
      pyg.cuota_coche ||= 0
      pyg.otras_cuotas ||= 0
      pyg.suscripciones ||= 0
      pyg.cuidado_personal ||= 0
    end

    # Savings - 30% checking, 70% savings
    if data[:ahorros].present?
      total_savings = data[:ahorros].to_i
      balance.dinero_cuenta_corriente = (total_savings * 0.3).round
      balance.dinero_cuenta_ahorro_depos = (total_savings * 0.7).round
    end

    # Investments - 50% investments, 50% pension plans
    if data[:inversiones].present? && data[:inversiones].to_i > 0
      total_inv = data[:inversiones].to_i
      balance.dinero_inversiones_f = (total_inv * 0.5).round
      balance.dinero_planes_pensiones = (total_inv * 0.5).round
    else
      balance.dinero_inversiones_f ||= 0
      balance.dinero_planes_pensiones ||= 0
    end

    # Real estate
    if data[:inmuebles].present? && data[:inmuebles].to_i > 0
      balance.valor_inmuebles = data[:inmuebles].to_i
    else
      balance.valor_inmuebles ||= 0
    end

    # Mortgage
    if data[:hipoteca].present? && data[:hipoteca].to_i > 0
      balance.hipoteca_inmuebles = data[:hipoteca].to_i
    else
      balance.hipoteca_inmuebles ||= 0
    end

    # Expensive debt - 60% credit card, 40% personal loans
    if data[:deuda_cara].present? && data[:deuda_cara].to_i > 0
      total_debt = data[:deuda_cara].to_i
      balance.deuda_tarjeta_credito = (total_debt * 0.6).round
      balance.prestamos_personales = (total_debt * 0.4).round
    else
      balance.deuda_tarjeta_credito ||= 0
      balance.prestamos_personales ||= 0
    end

    # Set remaining balance fields to 0 if not set
    balance.valor_coches_vehiculos ||= 0
    balance.valor_otros_activos ||= 0
    balance.prestamos_coches ||= 0
    balance.otras_deudas ||= 0

    # Save risk profile
    if data[:riesgo].present?
      current_user.update_column(:risk_profile, data[:riesgo].to_i.clamp(1, 3))
    end

    if pyg.save && balance.save
      session.delete(:onboarding)
      redirect_to onboarding_processing_path(from: from)
    else
      flash[:alert] = t('onboarding.save_error')
      redirect_to onboarding_step_path(step_name: 'ingresos', from: from)
    end
  end
end
