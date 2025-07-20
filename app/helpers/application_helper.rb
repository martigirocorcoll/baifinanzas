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
end
