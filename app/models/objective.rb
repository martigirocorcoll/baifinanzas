class Objective < ApplicationRecord
  belongs_to :user

  validates :title, presence: { message: "El título es obligatorio" }
  validates :target_amount, presence: { message: "El importe objetivo es obligatorio" },
            numericality: { only_integer: true, greater_than: 0, message: "El importe debe ser mayor a 0€" }
  validates :target_date, presence: { message: "La fecha objetivo es obligatoria" }
  
  validate :fecha_objetivo_futura

  def valid_for_display?
    title.present? && target_amount.present? && target_amount > 0 && target_date.present?
  end

  def months_to_target
    return 0 unless target_date.present?
    ((target_date - Date.current) / 30.44).round
  end

  def years_to_target
    months_to_target / 12.0
  end

  def is_retirement_objective?
    return false unless title.present?
    title.downcase.include?('jubil') || title.downcase.include?('pension') || title.downcase.include?('retir')
  end

  def investment_recommendation
    if is_retirement_objective?
      "ac_jubil"
    elsif years_to_target <= 2
      "ac_diposit"
    elsif years_to_target <= 5
      "ac_curt"
    else
      "ac_llarg"
    end
  end

  def annual_return_rate
    case investment_recommendation
    when "ac_diposit"
      0.015
    when "ac_curt"
      0.03
    when "ac_llarg", "ac_jubil"
      0.08
    end
  end
  
  # Alias para compatibilidad con el controlador
  def expected_return
    annual_return_rate
  end

  def monthly_savings_needed
    return target_amount unless target_date.present?
    return target_amount if months_to_target <= 0
    
    monthly_rate = annual_return_rate / 12
    periods = months_to_target
    
    if monthly_rate == 0
      target_amount / periods
    else
      target_amount / (((1 + monthly_rate) ** periods - 1) / monthly_rate)
    end.round(2)
  end

  def savings_capacity_analysis
    return { sufficient: false, message: "Usuario sin datos financieros" } unless user.balance && user.pyg
    
    monthly_needed = monthly_savings_needed
    available_cash_flow = user.monthly_cash_flow
    
    if available_cash_flow >= monthly_needed
      {
        sufficient: true,
        monthly_needed: monthly_needed,
        available_cash_flow: available_cash_flow,
        surplus: available_cash_flow - monthly_needed
      }
    else
      {
        sufficient: false,
        monthly_needed: monthly_needed,
        available_cash_flow: available_cash_flow,
        deficit: monthly_needed - available_cash_flow
      }
    end
  end

  private

  def fecha_objetivo_futura
    return unless target_date.present?
    
    if target_date <= Date.current
      errors.add(:target_date, "La fecha objetivo debe ser futura")
    end
  end
end
