class OnboardingController < ApplicationController
  layout 'app'

  def welcome
    # Check onboarding status and redirect if necessary
    if current_user.has_basic_financial_data?
      redirect_to home_path and return
    end
    # Otherwise, show welcome page (user has no data yet)
  end

  def basic
    # Quick onboarding with 4 fields
    @pyg = current_user.pyg || current_user.build_pyg
    @balance = current_user.balance || current_user.build_balance

    # If user already has basic data, redirect to home
    if current_user.has_basic_financial_data?
      redirect_to home_path and return
    end
  end

  def save_basic
    @pyg = current_user.pyg || current_user.build_pyg
    @balance = current_user.balance || current_user.build_balance

    # Parse and save basic data
    # Monthly income
    if params[:ingresos_mensual].present?
      @pyg.ingresos_mensual = params[:ingresos_mensual].to_f
    end

    # Monthly expenses (total, will be distributed later)
    if params[:gastos_mensual].present?
      total_expenses = params[:gastos_mensual].to_f
      # Distribute roughly across categories for now
      @pyg.gasto_compra = (total_expenses * 0.25).round(2)
      @pyg.alquiler_hipoteca = (total_expenses * 0.35).round(2)
      @pyg.gastos_utilities = (total_expenses * 0.10).round(2)
      @pyg.gastos_transporte = (total_expenses * 0.10).round(2)
      @pyg.restaurantes_y_ocio = (total_expenses * 0.10).round(2)
      @pyg.otros_gastos = (total_expenses * 0.10).round(2)
      # Set others to 0
      @pyg.gastos_seguros ||= 0
      @pyg.cuota_hipoteca ||= 0
      @pyg.cuota_coche ||= 0
      @pyg.otras_cuotas ||= 0
      @pyg.suscripciones ||= 0
      @pyg.cuidado_personal ||= 0
    end

    # Total savings
    if params[:ahorros_totales].present?
      total_savings = params[:ahorros_totales].to_f
      # Distribute between checking and savings accounts
      @balance.dinero_cuenta_corriente = (total_savings * 0.3).round(2)
      @balance.dinero_cuenta_ahorro_depos = (total_savings * 0.7).round(2)
      # Set others to 0 if not set
      @balance.valor_inmuebles ||= 0
      @balance.dinero_inversiones_f ||= 0
      @balance.dinero_planes_pensiones ||= 0
      @balance.valor_coches_vehiculos ||= 0
      @balance.valor_otros_activos ||= 0
    end

    # Total debt
    if params[:deudas_totales].present?
      total_debt = params[:deudas_totales].to_f
      # Put all debt in "otras_deudas" for now
      @balance.otras_deudas = total_debt
      # Set others to 0 if not set
      @balance.hipoteca_inmuebles ||= 0
      @balance.deuda_tarjeta_credito ||= 0
      @balance.prestamos_personales ||= 0
      @balance.prestamos_coches ||= 0
    end

    if @pyg.save && @balance.save
      redirect_to onboarding_complete_path
    else
      flash.now[:alert] = t('onboarding.save_error', default: 'Error saving your data. Please try again.')
      render :basic, status: :unprocessable_entity
    end
  end

  def complete
    # Show completion screen with financial level
    @financial_level = {
      key: current_user.financial_health_level_key,
      number: current_user.financial_health_level_number,
      name: t("financial.levels.#{current_user.financial_health_level_key}.name"),
      icon: t("financial.levels.#{current_user.financial_health_level_key}.bootstrap_icon")
    }
  end

  def processing
    # Loading screen that shows for 3 seconds before redirecting to home
    # Auto-redirects via JavaScript after animation completes
  end
end
