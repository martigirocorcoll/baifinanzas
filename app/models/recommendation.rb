class Recommendation < ApplicationRecord
  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true
  validates :description, presence: true
  
  scope :active, -> { where(active: true) }
  
  def to_param
    slug
  end
  
  # Método para obtener el contenido contextualizado según el objetivo
  def contextual_title(objective = nil)
    if objective.present?
      "#{title} para: #{objective.title}"
    else
      title
    end
  end
  
  def contextual_description(objective = nil)
    if objective.present?
      "#{description} Este producto es especialmente recomendado para tu objetivo de #{objective.title.downcase} por #{contextual_reason(objective)}."
    else
      description
    end
  end
  
  private
  
  def contextual_reason(objective)
    case slug
    when "ac_diposit"
      "su liquidez y seguridad a corto plazo"
    when "ac_curt" 
      "su equilibrio entre rentabilidad y riesgo moderado"
    when "ac_llarg", "ac_jubil"
      "su potencial de crecimiento a largo plazo"
    else
      "sus características específicas"
    end
  end
end
