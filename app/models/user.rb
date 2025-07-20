class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :influencer, optional: true

  has_one  :pyg,     dependent: :destroy
  has_one  :balance, dependent: :destroy
  has_many :objectives, dependent: :destroy

  # Create default PYG and Balance after user signup
  after_create :build_default_financials

  def financial_health_level
    return "Iniciando" unless balance && pyg
    
    if libertad_financiera?
      "Libertad Financiera"
    elsif acomodado?
      "Acomodado"
    elsif invirtiendo_en_objetivos?
      "Invirtiendo en Objetivos"
    elsif liberandose_de_deudas?
      "Liberándose de Deudas"
    elsif construyendo_base?
      "Construyendo Base"
    else
      "Iniciando"
    end
  end

  def monthly_cash_flow
    monthly_income - monthly_expenses
  end

  def emergency_fund_target
    monthly_expenses * 3
  end

  def has_emergency_fund?
    liquid_assets >= emergency_fund_target
  end

  def expensive_debt
    return 0 unless balance
    balance.deuda_tarjeta_credito + balance.prestamos_personales
  end

  def has_expensive_debt?
    expensive_debt > 0
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
    
    high_yield_assets = balance.dinero_cuenta_corriente + 
                       balance.dinero_cuenta_ahorro_depos +
                       balance.dinero_inversiones_f + 
                       balance.dinero_planes_pensiones
    
    real_estate_income = balance.valor_inmuebles * 0.015 / 12
    other_investments_income = high_yield_assets * 0.035 / 12
    
    (real_estate_income + other_investments_income).round(2)
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
    objectives.where(status: 'active').map(&:investment_recommendation).uniq
  end

  def get_affiliate_link(product_type)
    return nil unless influencer
    
    case product_type
    when "better_bank_account", "emergency_account", "investment_account", "debt_repayment_account"
      influencer.ac_compte
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
    ["Invirtiendo en Objetivos", "Acomodado", "Libertad Financiera"].include?(financial_health_level)
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
    case financial_health_level
    when "Iniciando"
      ["saving_advice", "debt_review", "better_bank_account"]
    when "Construyendo Base"
      ["emergency_account", "debt_review"]
    when "Liberándose de Deudas"
      ["debt_repayment_account", "debt_optimization"]
    when "Invirtiendo en Objetivos"
      ["investment_account", "mortgage_optimization", "investment_plan"]
    when "Acomodado"
      ["investment_account", "mortgage_optimization", "investment_plan", "portfolio_optimization"]
    when "Libertad Financiera"
      ["comprehensive_review"]
    else
      []
    end
  end


  def total_assets
    return 0 unless balance
    balance.valor_inmuebles + balance.dinero_cuenta_corriente + 
    balance.dinero_cuenta_ahorro_depos + balance.dinero_inversiones_f +
    balance.dinero_planes_pensiones + balance.valor_coches_vehiculos + 
    balance.valor_otros_activos
  end

  private

  def build_default_financials
    create_pyg
    create_balance
  end

  def total_debts
    return 0 unless balance
    balance.hipoteca_inmuebles + balance.deuda_tarjeta_credito +
    balance.prestamos_personales + balance.prestamos_coches + balance.otras_deudas
  end

  def liquid_assets
    return 0 unless balance
    balance.dinero_cuenta_corriente + balance.dinero_cuenta_ahorro_depos
  end

  def libertad_financiera?
    has_financial_freedom?
  end

  def acomodado?
    net_worth >= 250000 && is_debt_free?
  end

  def invirtiendo_en_objetivos?
    has_emergency_fund? && !has_expensive_debt? && monthly_cash_flow > 0
  end

  def liberandose_de_deudas?
    has_emergency_fund? && has_expensive_debt?
  end

  def construyendo_base?
    monthly_cash_flow > 0 && !has_emergency_fund?
  end
end
