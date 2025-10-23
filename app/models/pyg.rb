class Pyg < ApplicationRecord
  before_validation :zeros_en_blanco


  belongs_to :user
  validates :user_id, uniqueness: true
  validates :ingresos_mensual,
            presence: { message: "Los ingresos mensuales son obligatorios" },
            numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Los ingresos no pueden ser negativos" }

  validates :gasto_compra, :alquiler_hipoteca, :gastos_utilities, :gastos_seguros,
            :gastos_transporte, :restaurantes_y_ocio, :cuota_hipoteca, :cuota_coche,
            :otras_cuotas, :suscripciones, :cuidado_personal, :otros_gastos,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Los gastos no pueden ser negativos" }

  # Check if PyG has real data (sum of all fields > 0)
  def has_data?
    total = (ingresos_mensual || 0) +
            (gasto_compra || 0) +
            (alquiler_hipoteca || 0) +
            (gastos_utilities || 0) +
            (gastos_seguros || 0) +
            (gastos_transporte || 0) +
            (restaurantes_y_ocio || 0) +
            (cuota_hipoteca || 0) +
            (cuota_coche || 0) +
            (otras_cuotas || 0) +
            (suscripciones || 0) +
            (cuidado_personal || 0) +
            (otros_gastos || 0)
    total > 0
  end

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
