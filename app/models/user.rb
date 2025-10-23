class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :influencer, optional: true

  has_one  :pyg,     dependent: :destroy
  has_one  :balance, dependent: :destroy
  has_many :objectives, dependent: :destroy
  has_many :user_actions, dependent: :destroy

  # Create default PYG and Balance after user signup
  after_create :build_default_financials
  after_create :assign_influencer_from_referral

  def admin?
    admin == true
  end

  def financial_health_level
    return "Situación Crítica" unless balance && pyg

    if libertad_financiera?
      "Libertad Financiera"
    elsif acomodado?
      "Crecimiento Patrimonial"
    elsif invirtiendo_en_objetivos?
      "Situación Estable"
    elsif liberandose_de_deudas?
      "Eliminando Deudas Caras"
    elsif construyendo_base?
      "Creando Fondo de Emergencia"
    else
      "Situación Crítica"
    end
  end

  def financial_health_level_number
    case financial_health_level
    when "Situación Crítica"
      1
    when "Creando Fondo de Emergencia"
      2
    when "Eliminando Deudas Caras"
      3
    when "Situación Estable"
      4
    when "Crecimiento Patrimonial"
      5
    when "Libertad Financiera"
      6
    else
      0
    end
  end

  def monthly_cash_flow
    monthly_income - monthly_expenses
  end

  def emergency_fund_target
    monthly_expenses * 4
  end

  def has_emergency_fund?
    liquid_assets >= emergency_fund_target
  end

  def has_partial_emergency_fund?
    liquid_assets >= (monthly_expenses * 2)
  end

  def expensive_debt
    return 0 unless balance
    balance.deuda_tarjeta_credito + balance.prestamos_personales
  end

  def has_expensive_debt?
    expensive_debt > 0
  end

  def expensive_debt_ratio
    return 0 if net_worth <= 0
    expensive_debt.to_f / net_worth
  end

  def net_worth
    total_assets - total_debt
  end

  def total_debt
    total_debts
  end

  def annual_income
    monthly_income * 12
  end

  def is_debt_free?
    return true if total_debt == 0
    
    debt_to_assets_ratio = total_debt.to_f / total_assets * 100
    debt_to_income_ratio = total_debt.to_f / annual_income
    
    debt_to_assets_ratio <= 15 || debt_to_income_ratio <= 2
  end

  def investment_income_monthly
    return 0 unless balance
    
    # Efectivo y ahorro: 0.5% anual
    cash_assets = balance.dinero_cuenta_corriente + balance.dinero_cuenta_ahorro_depos
    cash_income = cash_assets * 0.005 / 12
    
    # Inversiones y pensiones: 4% anual  
    investment_assets = balance.dinero_inversiones_f + balance.dinero_planes_pensiones
    investment_income = investment_assets * 0.04 / 12
    
    # Inmuebles: 1.5% anual
    real_estate_income = balance.valor_inmuebles * 0.015 / 12
    
    (cash_income + investment_income + real_estate_income).round(2)
  end

  def has_financial_freedom?
    investment_income_monthly >= monthly_expenses
  end

  def financial_recommendations
    recommendations = base_financial_recommendations
    
    # Add objective-specific recommendations for users who can invest
    if can_invest_in_objectives?
      recommendations += objective_recommendations
    end
    
    recommendations
  end

  def objective_recommendations
    objectives.select(&:valid_for_display?).map(&:investment_recommendation).uniq
  end

  def get_affiliate_link(product_type)
    return nil unless influencer
    
    case product_type
    when "better_bank_account"
      influencer.ac_compte
    when "emergency_deposit"
      influencer.ac_cdiposit
    when "ac_diposit"
      influencer.ac_cdiposit
    when "ac_curt"
      influencer.ac_curt
    when "ac_llarg"
      influencer.ac_llarg
    when "ac_jubil"
      influencer.ac_jubil
    when "debt_review", "debt_optimization", "mortgage_optimization"
      influencer.ac_deute
    when "portfolio_optimization"
      influencer.ac_llarg  # Portfolio avanzada usa inversión a largo plazo
    when "saving_advice"
      influencer.ac_compte  # Asesoramiento de ahorro relacionado con cuentas
    when "tax_advisory"
      influencer.ac_fiscal
    else
      nil
    end
  end

  def recommendations_with_links
    financial_recommendations.map do |recommendation|
      {
        product: recommendation,
        affiliate_link: get_affiliate_link(recommendation)
      }
    end
  end

  def can_invest_in_objectives?
    ["Situación Estable", "Crecimiento Patrimonial", "Libertad Financiera"].include?(financial_health_level)
  end

  def monthly_income
    return 0 unless pyg
    pyg.ingresos_mensual
  end

  def monthly_expenses
    return 0 unless pyg
    pyg.gasto_compra + pyg.alquiler_hipoteca + pyg.gastos_utilities +
    pyg.gastos_seguros + pyg.gastos_transporte + pyg.restaurantes_y_ocio +
    pyg.cuota_hipoteca + pyg.cuota_coche + pyg.otras_cuotas +
    pyg.suscripciones + pyg.cuidado_personal + pyg.otros_gastos
  end

  def base_financial_recommendations
    recommendations = []

    case financial_health_level
    when "Situación Crítica"
      # Priority: Create cash flow, optimize bank, review debts
      recommendations = ["saving_advice", "better_bank_account"]
      recommendations << "debt_review" if total_debt > 0
      recommendations << "mortgage_optimization" if has_mortgage?  # Hipoteca en TODOS los niveles
    when "Creando Fondo de Emergencia"
      # Priority: Build emergency fund, optimize bank
      recommendations = ["emergency_deposit", "better_bank_account"]
      recommendations << "debt_review" if total_debt > 0
      recommendations << "mortgage_optimization" if has_mortgage?
    when "Eliminando Deudas Caras"
      # Priority: Pay off expensive debt, maintain emergency fund
      recommendations = ["debt_optimization", "emergency_deposit", "better_bank_account"]
      recommendations << "mortgage_optimization" if has_mortgage?
    when "Situación Estable"
      # Priority: Maintain stability, optimize assets
      recommendations = ["better_bank_account", "emergency_deposit"]
      recommendations << "mortgage_optimization" if has_mortgage?
    when "Crecimiento Patrimonial"
      # Priority: Grow wealth through investments
      recommendations = ["portfolio_optimization", "better_bank_account", "emergency_deposit"]
      recommendations << "mortgage_optimization" if has_mortgage?
    when "Libertad Financiera"
      # Priority: Preserve wealth, optimize taxes
      recommendations = ["tax_advisory", "portfolio_optimization", "better_bank_account", "emergency_deposit"]
      recommendations << "mortgage_optimization" if has_mortgage?
    else
      recommendations = []
    end

    recommendations
  end


  def total_assets
    return 0 unless balance
    balance.valor_inmuebles + balance.dinero_cuenta_corriente + 
    balance.dinero_cuenta_ahorro_depos + balance.dinero_inversiones_f +
    balance.dinero_planes_pensiones + balance.valor_coches_vehiculos + 
    balance.valor_otros_activos
  end

  def liquid_assets
    return 0 unless balance
    balance.dinero_cuenta_corriente + 
    balance.dinero_cuenta_ahorro_depos + 
    balance.dinero_inversiones_f
  end

  def has_mortgage?
    return false unless balance
    (balance.hipoteca_inmuebles || 0) > 0
  end

  def assign_influencer_from_code(code)
    return unless code.present?
    influencer = Influencer.find_by(code: code)
    update(influencer: influencer) if influencer
  end

  # ============================================
  # ACTION PLAN - Plan de acción unificado
  # ============================================

  def action_plan
    actions = []

    # 1. Añadir recomendaciones base según nivel
    base_financial_recommendations.each do |rec_key|
      # Convertir rec_key a slug (better_bank_account → better-bank-account)
      slug = rec_key.dasherize
      recommendation = Recommendation.find_by(slug: slug)

      actions << {
        position: actions.length + 1,
        type: 'recommendation',
        key: rec_key,
        slug: slug,
        title: recommendation&.title || recommendation_title(rec_key),
        benefit_text: recommendation_benefit_text(rec_key),
        icon: recommendation_icon(rec_key),
        time_minutes: recommendation_time(rec_key),
        completed: completed_recommendations.include?(rec_key),
        recommendation: recommendation
      }
    end

    # 2. Insertar objetivos en posición correcta (si el usuario puede tenerlos)
    if can_invest_in_objectives?
      valid_objectives = objectives.select(&:valid_for_display?)

      # Añadir objetivos existentes
      valid_objectives.each do |obj|
        actions << {
          position: actions.length + 1,
          type: 'objective',
          title: obj.title,
          benefit_text: "Alcanza tu meta de #{ActionController::Base.helpers.number_to_currency(obj.target_amount, unit: '€', precision: 0)}",
          icon: "🎯",
          time_months: obj.months_to_target,
          completed: false, # Los objetivos no se marcan como completados en el action plan
          objective: {
            id: obj.id,
            title: obj.title,
            target_amount: obj.target_amount,
            target_date: obj.target_date,
            monthly_savings_needed: obj.monthly_savings_needed,
            investment_recommendation: obj.investment_recommendation
          }
        }
      end

      # Siempre añadir la opción de crear un nuevo objetivo (puede haber múltiples objetivos)
      actions << {
        position: actions.length + 1,
        type: 'create_objective',
        title: valid_objectives.any? ? 'Crear nuevo objetivo' : 'Define tu primer objetivo',
        benefit_text: "Planifica tu futuro financiero",
        icon: "🎯",
        completed: false
      }
    end

    actions
  end

  def current_task
    action_plan.find { |action| !action[:completed] }
  end

  def completed_recommendations
    user_actions.completed.where(action_type: 'recommendation').pluck(:action_key)
  end

  def complete_recommendation!(rec_key)
    user_actions.find_or_create_by(
      action_type: 'recommendation',
      action_key: rec_key
    ).mark_completed!
  end

  def complete_objective!(objective_id)
    user_actions.find_or_create_by(
      action_type: 'objective',
      action_key: objective_id.to_s
    ).mark_completed!
  end

  def recommendation_title(rec_key)
    case rec_key
    when 'better_bank_account'
      "Optimiza tu Cuenta Bancaria"
    when 'emergency_deposit', 'ac_cdiposit'
      "Construye tu Fondo de Emergencia"
    when 'debt_optimization', 'debt_review'
      "Optimiza tus Deudas"
    when 'mortgage_optimization'
      "Optimiza tu Hipoteca"
    when 'portfolio_optimization'
      "Optimiza tus Inversiones"
    when 'tax_advisory', 'ac_fiscal'
      "Optimización Fiscal"
    when 'saving_advice'
      "Asesoramiento de Ahorro"
    when 'ac_curt'
      "Inversión a Medio Plazo"
    when 'ac_llarg'
      "Inversión a Largo Plazo"
    when 'ac_jubil'
      "Planifica tu Jubilación"
    else
      rec_key.titleize
    end
  end

  def recommendation_benefit_text(rec_key)
    case rec_key
    when 'better_bank_account'
      "Elimina comisiones innecesarias"
    when 'emergency_deposit', 'ac_cdiposit'
      "Protege tus ahorros ante imprevistos"
    when 'debt_optimization', 'debt_review'
      "Reduce el peso de tus deudas"
    when 'mortgage_optimization'
      "Paga menos por tu hipoteca"
    when 'portfolio_optimization'
      "Maximiza el rendimiento de tus inversiones"
    when 'tax_advisory', 'ac_fiscal'
      "Optimiza tu situación fiscal"
    when 'saving_advice'
      "Identifica oportunidades de ahorro"
    when 'ac_curt'
      "Haz crecer tu dinero a medio plazo"
    when 'ac_llarg'
      "Construye patrimonio a largo plazo"
    when 'ac_jubil'
      "Asegura tu futuro financiero"
    else
      "Mejora tu situación financiera"
    end
  end

  def recommendation_icon(rec_key)
    case rec_key
    when 'better_bank_account'
      "💳"
    when 'emergency_deposit', 'ac_cdiposit'
      "🛡️"
    when 'debt_optimization', 'debt_review'
      "📉"
    when 'mortgage_optimization'
      "🏠"
    when 'portfolio_optimization'
      "📈"
    when 'tax_advisory', 'ac_fiscal'
      "💼"
    when 'saving_advice'
      "💡"
    when 'ac_curt'
      "🎯"
    when 'ac_llarg'
      "🚀"
    when 'ac_jubil'
      "🏖️"
    else
      "✅"
    end
  end

  def recommendation_time(rec_key)
    # Tiempo estimado en minutos para completar cada acción
    case rec_key
    when 'better_bank_account'
      20
    when 'emergency_deposit', 'ac_cdiposit'
      15
    when 'debt_optimization', 'debt_review'
      30
    when 'mortgage_optimization'
      25
    when 'portfolio_optimization'
      30
    when 'tax_advisory', 'ac_fiscal'
      20
    when 'saving_advice'
      15
    when 'ac_curt', 'ac_llarg', 'ac_jubil'
      20
    else
      20
    end
  end

  private

  def build_default_financials
    create_pyg
    create_balance
  end

  def assign_influencer_from_referral
    # If no influencer assigned and there's a default influencer, assign it
    if influencer.nil?
      default_inf = Influencer.default_influencer
      update(influencer: default_inf) if default_inf.present?
    end
  end

  def total_debts
    return 0 unless balance
    balance.hipoteca_inmuebles + balance.deuda_tarjeta_credito +
    balance.prestamos_personales + balance.prestamos_coches + balance.otras_deudas
  end

  def libertad_financiera?
    has_financial_freedom?
  end

  def acomodado?
    has_emergency_fund? && 
    monthly_cash_flow > 0 && 
    net_worth >= (annual_income * 2)
  end

  def invirtiendo_en_objetivos?
    has_emergency_fund? && monthly_cash_flow > 0 && expensive_debt_ratio < 0.4
  end

  def liberandose_de_deudas?
    monthly_cash_flow > 0 && has_partial_emergency_fund? && has_expensive_debt?
  end

  def construyendo_base?
    monthly_cash_flow > 0
  end
end
