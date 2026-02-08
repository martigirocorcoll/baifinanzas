module RecommendationData
  Recommendation = Struct.new(:slug, :category, keyword_init: true) do
    def to_param = slug
    def slug_key = slug.tr('-', '_')
    def title = I18n.t("financial.recommendations.#{slug_key}.title", default: "Recomendacion")
    def description = I18n.t("financial.recommendations.#{slug_key}.description", default: "")
    def icon = I18n.t("financial.recommendations.#{slug_key}.icon", default: "bi-check-circle")
    def content = nil
    def video_url = nil

    def contextual_title(objective = nil)
      objective.present? ? "#{title} para: #{objective.title}" : title
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
      when "ac-diposit"
        "su liquidez y seguridad a corto plazo"
      when "ac-curt"
        "su equilibrio entre rentabilidad y riesgo moderado"
      when "ac-llarg", "ac-jubil"
        "su potencial de crecimiento a largo plazo"
      else
        "sus caracteristicas especificas"
      end
    end
  end

  ALL = [
    Recommendation.new(slug: "ac-diposit", category: "depositos"),
    Recommendation.new(slug: "ac-curt", category: "fondos"),
    Recommendation.new(slug: "ac-llarg", category: "fondos"),
    Recommendation.new(slug: "ac-jubil", category: "planes_pensiones"),
    Recommendation.new(slug: "better-bank-account", category: "cuentas"),
    Recommendation.new(slug: "emergency-deposit", category: "emergencia"),
    Recommendation.new(slug: "saving-advice", category: "consejos"),
    Recommendation.new(slug: "debt-optimization", category: "deudas"),
    Recommendation.new(slug: "mortgage-optimization", category: "hipoteca"),
    Recommendation.new(slug: "tax-advisory", category: "fiscal"),
    Recommendation.new(slug: "portfolio-optimization", category: "inversiones"),
  ].freeze

  BY_SLUG = ALL.index_by(&:slug).freeze

  def self.find_by_slug(slug) = BY_SLUG[slug]
  def self.find_by_slug!(slug) = BY_SLUG[slug] || raise(ActiveRecord::RecordNotFound)
  def self.all = ALL
end
