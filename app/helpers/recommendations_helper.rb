module RecommendationsHelper
  def recommendation_icon(slug)
    case slug
    when 'better-bank-account'
      'bi-bank'
    when 'emergency-deposit'
      'bi-shield-check'
    when 'saving-advice'
      'bi-lightbulb'
    when 'debt-optimization'
      'bi-credit-card-2-back'
    when 'mortgage-optimization'
      'bi-house-door'
    when 'ac-curt'
      'bi-bar-chart'
    when 'ac-llarg'
      'bi-graph-up'
    when 'ac-jubil'
      'bi-piggy-bank-fill'
    when 'portfolio-optimization'
      'bi-graph-up-arrow'
    when 'tax-advisory'
      'bi-calculator'
    else
      'bi-check-circle'
    end
  end
end
