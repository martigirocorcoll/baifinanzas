class Pyg < ApplicationRecord
  before_validation :zeros_en_blanco


  belongs_to :user
  validates :user_id, uniqueness: true
  validates :ingresos_mensual, :gasto_compra, :alquiler_hipoteca,
            :gastos_utilities, :gastos_seguros, :gastos_transporte,
            :restaurantes_y_ocio, :cuota_hipoteca, :cuota_coche,
            :otras_cuotas, :suscripciones, :cuidado_personal,
            :otros_gastos,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

  def zeros_en_blanco
    %i[
      ingresos_mensual gasto_compra alquiler_hipoteca gastos_utilities
      gastos_seguros gastos_transporte restaurantes_y_ocio cuota_hipoteca
      cuota_coche otras_cuotas suscripciones cuidado_personal otros_gastos
    ].each do |attr|
      # si viene como nil o como cadena vacía, lo configuramos a 0
      self[attr] = 0 if self[attr].blank?
    end
  end
end
