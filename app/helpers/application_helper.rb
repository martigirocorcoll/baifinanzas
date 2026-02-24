module ApplicationHelper
  def get_objective_icon(categoria)
    case categoria&.downcase
    when 'vivienda' then 'house'
    when 'vehiculo' then 'car-front'
    when 'viaje' then 'airplane'
    when 'educacion' then 'book'
    when 'jubilacion' then 'person-badge'
    else 'target'
    end
  end

  def financial_health_allows_objectives?
    return false unless current_user&.financial_health_level
    ["Invirtiendo en Objetivos", "Acomodado", "Libertad Financiera"].include?(current_user.financial_health_level)
  end

  def tooltip_term(text, tooltip_key)
    tooltip_text = t("tooltips.#{tooltip_key}")
    content_tag(:span, class: 'tooltip-term') do
      concat(text.to_s)
      concat(content_tag(:button, '?', class: 'tooltip-trigger',
             data: { tooltip: tooltip_text }, type: 'button',
             'aria-label' => tooltip_text))
    end
  end

  def format_currency(amount)
    number_to_currency(amount, unit: 'EUR', precision: 0, format: '%n %u', delimiter: '.')
  end
end
