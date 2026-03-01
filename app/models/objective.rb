class Objective < ApplicationRecord
  belongs_to :user

  # Validations use Rails I18n automatically from activerecord.errors.models.objective
  validates :title, presence: true
  validates :target_amount, presence: true,
            numericality: { only_integer: true, greater_than: 0 }
  validates :target_date, presence: true

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

    # Get keywords from both locales
    es_keywords = I18n.t('objectives.icon_keywords.retirement', locale: :es, default: '')
    en_keywords = I18n.t('objectives.icon_keywords.retirement', locale: :en, default: '')
    all_keywords = "#{es_keywords}|#{en_keywords}"

    title.downcase.match?(Regexp.new(all_keywords, Regexp::IGNORECASE))
  end

  def investment_recommendation
    risk = user&.risk_profile || 2 # Default: medium

    if is_retirement_objective?
      risk >= 2 ? "ac_jubil" : "ac_curt"
    elsif years_to_target <= 2
      risk >= 3 ? "ac_curt" : "ac_diposit"
    elsif years_to_target <= 5
      case risk
      when 1 then "ac_diposit"
      when 2 then "ac_curt"
      else "ac_llarg"
      end
    else
      risk <= 1 ? "ac_curt" : "ac_llarg"
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

  def remaining_amount
    [target_amount - current_amount, 0].max
  end

  def monthly_savings_needed
    remaining = remaining_amount
    return 0 if remaining <= 0
    return remaining unless target_date.present?
    return remaining if months_to_target <= 0

    monthly_rate = annual_return_rate / 12
    periods = months_to_target

    if monthly_rate == 0
      remaining.to_f / periods
    else
      remaining / (((1 + monthly_rate) ** periods - 1) / monthly_rate)
    end.round(2)
  end

  def savings_capacity_analysis
    return { sufficient: false, message: I18n.t('dashboard.savings_capacity.no_data', default: 'No financial data') } unless user.balance && user.pyg

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

  def objective_icon
    return "bi-bullseye" unless title.present?

    title_lower = title.downcase

    # Check each icon type against both language keywords
    icon_types = {
      house: "bi-house-heart",
      car: "bi-car-front",
      education: "bi-mortarboard",
      retirement: "bi-piggy-bank-fill",
      travel: "bi-airplane",
      wedding: "bi-heart",
      emergency: "bi-shield-check",
      investment: "bi-graph-up-arrow",
      debt: "bi-credit-card-2-back",
      business: "bi-briefcase",
      health: "bi-heart-pulse",
      family: "bi-people"
    }

    icon_types.each do |icon_type, icon_class|
      es_keywords = I18n.t("objectives.icon_keywords.#{icon_type}", locale: :es, default: '')
      en_keywords = I18n.t("objectives.icon_keywords.#{icon_type}", locale: :en, default: '')
      all_keywords = "#{es_keywords}|#{en_keywords}".gsub('||', '|')

      if all_keywords.present? && title_lower.match?(Regexp.new(all_keywords, Regexp::IGNORECASE))
        return icon_class
      end
    end

    # Default
    "bi-bullseye"
  end

  def objective_icon_emoji
    return "" unless title.present?

    title_lower = title.downcase

    # Map keywords to emojis
    emoji_map = {
      house: "",
      car: "",
      education: "",
      retirement: "",
      travel: "",
      wedding: "",
      emergency: "",
      investment: "",
      debt: "",
      business: "",
      health: "",
      family: ""
    }

    emoji_map.each do |icon_type, emoji|
      es_keywords = I18n.t("objectives.icon_keywords.#{icon_type}", locale: :es, default: '')
      en_keywords = I18n.t("objectives.icon_keywords.#{icon_type}", locale: :en, default: '')
      all_keywords = "#{es_keywords}|#{en_keywords}".gsub('||', '|')

      if all_keywords.present? && title_lower.match?(Regexp.new(all_keywords, Regexp::IGNORECASE))
        return emoji
      end
    end

    # Default
    ""
  end

  def current_progress_percentage
    return 0 unless target_amount.present? && target_amount > 0
    ((current_amount.to_f / target_amount) * 100).clamp(0, 100)
  end

  private

  def fecha_objetivo_futura
    return unless target_date.present?

    if target_date <= Date.current
      errors.add(:target_date, :must_be_future)
    end
  end
end
