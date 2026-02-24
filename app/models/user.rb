class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Referral: which influencer referred this user
  belongs_to :influencer, optional: true

  # If this user IS an influencer, their profile data
  has_one :influencer_profile, class_name: "Influencer", foreign_key: "user_id", dependent: :nullify

  has_one  :pyg,     dependent: :destroy
  has_one  :balance, dependent: :destroy
  has_many :objectives, dependent: :destroy
  has_many :user_actions, dependent: :destroy

  # Create default PYG and Balance after user signup
  after_create :build_default_financials
  after_create :assign_influencer_from_referral

  # Role helpers
  def admin?
    role == "admin"
  end

  def influencer?
    role == "influencer"
  end

  def regular?
    role == "user"
  end

  def pyg_completed?
    pyg.present? && pyg.ingresos_mensual.present? && pyg.ingresos_mensual > 0
  end

  def balance_completed?
    balance.present? && (total_assets > 0 || total_debt > 0)
  end

  def profile_complete?
    pyg_completed? && balance_completed?
  end

  def onboarding_only?
    has_basic_financial_data? && !profile_complete?
  end

  # Check if user has completed basic onboarding (4 fields minimum)
  def has_basic_financial_data?
    return false unless pyg.present? && pyg.ingresos_mensual.present? && pyg.ingresos_mensual > 0
    true
  end

  # Check if user has complete financial data (detailed PyG + Balance)
  def has_complete_financial_data?
    has_basic_financial_data? &&
    balance.present? &&
    (total_assets > 0 || total_debt > 0)
  end

  def completed_objectives
    user_actions.completed.where(action_type: 'objective').pluck(:action_key).map(&:to_i)
  end

  # Returns a symbol representing the financial health level
  def financial_health_level_key
    return :critical unless balance && pyg

    if libertad_financiera?
      :financial_freedom
    elsif acomodado?
      :growth
    elsif invirtiendo_en_objetivos?
      :stable
    elsif liberandose_de_deudas?
      :paying_debt
    elsif construyendo_base?
      :emergency_fund
    else
      :critical
    end
  end

  # Returns the translated name of the financial health level
  def financial_health_level
    I18n.t("financial.levels.#{financial_health_level_key}.name")
  end

  def financial_health_level_number
    case financial_health_level_key
    when :critical
      1
    when :emergency_fund
      2
    when :paying_debt
      3
    when :stable
      4
    when :growth
      5
    when :financial_freedom
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
    # Usar el influencer asignado o el por defecto
    inf = influencer || Influencer.default_influencer
    return nil unless inf

    case product_type
    when "better_bank_account"
      inf.ac_compte
    when "emergency_deposit", "ac_diposit"
      inf.ac_cdiposit
    when "saving_advice"
      inf.ac_saving
    when "debt_review", "debt_optimization"
      inf.ac_deute
    when "mortgage_optimization"
      inf.ac_mortgage
    when "ac_curt"
      inf.ac_curt
    when "ac_llarg"
      inf.ac_llarg
    when "ac_jubil"
      inf.ac_jubil
    when "portfolio_optimization"
      inf.ac_portfolio
    when "tax_advisory"
      inf.ac_fiscal
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
    [:stable, :growth, :financial_freedom].include?(financial_health_level_key)
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

    case financial_health_level_key
    when :critical
      # Priority: Create cash flow, optimize bank, review debts
      recommendations = ["saving_advice", "better_bank_account"]
      recommendations << "debt_optimization" if total_debt > 0
      recommendations << "mortgage_optimization" if has_mortgage?
    when :emergency_fund
      # Priority: Build emergency fund, optimize bank
      recommendations = ["emergency_deposit", "better_bank_account"]
      recommendations << "debt_optimization" if total_debt > 0
      recommendations << "mortgage_optimization" if has_mortgage?
    when :paying_debt
      # Priority: Pay off expensive debt, maintain emergency fund
      recommendations = ["debt_optimization", "emergency_deposit", "better_bank_account"]
      recommendations << "mortgage_optimization" if has_mortgage?
    when :stable
      # Priority: Maintain stability, optimize assets
      recommendations = ["better_bank_account", "emergency_deposit"]
      recommendations << "mortgage_optimization" if has_mortgage?
    when :growth
      # Priority: Grow wealth through investments
      recommendations = ["portfolio_optimization", "better_bank_account", "emergency_deposit"]
      recommendations << "mortgage_optimization" if has_mortgage?
    when :financial_freedom
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

  # Obtener URL del video segun el slug de la recomendacion
  def get_video_url(slug)
    # Try user's referral influencer first, then fall back to default
    [influencer, Influencer.default_influencer].compact.uniq.each do |inf|
      url = video_url_from_influencer(inf, slug)
      return url if url.present?
    end
    nil
  end

  def video_url_from_influencer(inf, slug)
    case slug
    when "better-bank-account"
      inf.video_compte
    when "emergency-deposit"
      inf.video_cdiposit
    when "debt-optimization"
      inf.video_deute
    when "saving-advice"
      inf.video_saving
    when "ac-llarg"
      inf.video_llarg
    when "ac-curt"
      inf.video_curt
    when "ac-jubil"
      inf.video_jubil
    when "tax-advisory"
      inf.video_fiscal
    when "portfolio-optimization"
      inf.video_portfolio
    when "mortgage-optimization"
      inf.video_mortgage
    else
      nil
    end
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
      recommendation = RecommendationData.find_by_slug(slug)

      actions << {
        position: actions.length + 1,
        type: 'recommendation',
        key: rec_key,
        slug: slug,
        title: recommendation_title(rec_key),
        benefit_text: recommendation_benefit_text(rec_key),
        icon: recommendation_icon(rec_key),
        time_minutes: recommendation_time(rec_key),
        completed: completed_recommendations.include?(rec_key),
        video_url: get_video_url(slug),
        recommendation: recommendation ? { slug: recommendation.slug, title: recommendation.title, description: recommendation.description } : nil
      }
    end

    # 2. Insertar objetivos en posición correcta (si el usuario puede tenerlos)
    if can_invest_in_objectives?
      valid_objectives = objectives.select(&:valid_for_display?)

      # Añadir objetivos existentes
      valid_objectives.each do |obj|
        # Obtener slug de la recomendación de inversión
        investment_slug = obj.investment_recommendation.dasherize
        formatted_amount = ActionController::Base.helpers.number_to_currency(obj.target_amount, unit: '€', precision: 0)

        actions << {
          position: actions.length + 1,
          type: 'objective',
          title: obj.title,
          benefit_text: I18n.t('financial.action_plan.reach_goal', amount: formatted_amount),
          icon: obj.objective_icon,
          time_months: obj.months_to_target,
          completed: false, # Los objetivos no se marcan como completados en el action plan
          video_url: get_video_url(investment_slug),
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
      title_key = valid_objectives.any? ? 'create_new_objective' : 'define_first_objective'
      actions << {
        position: actions.length + 1,
        type: 'create_objective',
        title: I18n.t("financial.action_plan.#{title_key}"),
        benefit_text: I18n.t('financial.action_plan.plan_future'),
        icon: "bi-plus-circle",
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

  def uncomplete_recommendation!(rec_key)
    action = user_actions.find_by(
      action_type: 'recommendation',
      action_key: rec_key
    )
    action&.destroy
  end

  def complete_objective!(objective_id)
    user_actions.find_or_create_by(
      action_type: 'objective',
      action_key: objective_id.to_s
    ).mark_completed!
  end

  def uncomplete_objective!(objective_id)
    action = user_actions.find_by(
      action_type: 'objective',
      action_key: objective_id.to_s
    )
    action&.destroy
  end

  def recommendation_title(rec_key)
    # Normalize key for lookup
    lookup_key = case rec_key
    when 'ac_cdiposit' then 'emergency_deposit'
    when 'debt_review' then 'debt_optimization'
    when 'ac_fiscal' then 'tax_advisory'
    else rec_key
    end

    I18n.t("financial.recommendations.#{lookup_key}.title",
           default: I18n.t("financial.recommendations.default.title"))
  end

  def recommendation_benefit_text(rec_key)
    # Normalize key for lookup
    lookup_key = case rec_key
    when 'ac_cdiposit' then 'emergency_deposit'
    when 'debt_review' then 'debt_optimization'
    when 'ac_fiscal' then 'tax_advisory'
    else rec_key
    end

    I18n.t("financial.recommendations.#{lookup_key}.benefit",
           default: I18n.t("financial.recommendations.default.benefit"))
  end

  def recommendation_icon(rec_key)
    case rec_key
    when 'better_bank_account'
      "bi-bank"
    when 'emergency_deposit', 'ac_cdiposit'
      "bi-shield-check"
    when 'debt_optimization', 'debt_review'
      "bi-credit-card-2-back"
    when 'mortgage_optimization'
      "bi-house-door"
    when 'portfolio_optimization'
      "bi-graph-up-arrow"
    when 'tax_advisory', 'ac_fiscal'
      "bi-calculator"
    when 'saving_advice'
      "bi-lightbulb"
    when 'ac_curt'
      "bi-bar-chart"
    when 'ac_llarg'
      "bi-graph-up"
    when 'ac_jubil'
      "bi-piggy-bank-fill"
    else
      "bi-check-circle"
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
