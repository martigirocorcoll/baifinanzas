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
    return "Valle Profundo" unless balance && pyg
    
    if libertad_financiera?
      "Cima Conquistada"
    elsif acomodado?
      "Alta Montaña"
    elsif invirtiendo_en_objetivos?
      "Cresta Estable"
    elsif liberandose_de_deudas?
      "Pared Vertical"
    elsif construyendo_base?
      "Campo Base"
    else
      "Valle Profundo"
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
    ["Cresta Estable", "Alta Montaña", "Cima Conquistada"].include?(financial_health_level)
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
    when "Valle Profundo"
      recommendations = ["saving_advice", "better_bank_account"]
      recommendations << "debt_review" if total_debt > 0
    when "Campo Base"
      recommendations = ["emergency_deposit", "better_bank_account"]
      recommendations << "debt_review" if total_debt > 0
    when "Pared Vertical"
      recommendations = ["emergency_deposit", "debt_optimization", "better_bank_account"]
    when "Cresta Estable"
      recommendations = ["better_bank_account", "emergency_deposit"]
      recommendations << "mortgage_optimization" if has_mortgage?
    when "Alta Montaña"
      recommendations = ["better_bank_account", "emergency_deposit", "portfolio_optimization"]
      recommendations << "mortgage_optimization" if has_mortgage?
    when "Cima Conquistada"
      recommendations = ["better_bank_account", "emergency_deposit", "portfolio_optimization", "tax_advisory"]
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
