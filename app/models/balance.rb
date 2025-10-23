class Balance < ApplicationRecord
  belongs_to :user

  before_validation :zeros_en_blanco

  validates :user_id, uniqueness: true

  validates :valor_inmuebles, :dinero_cuenta_corriente,
            :dinero_cuenta_ahorro_depos, :dinero_inversiones_f,
            :dinero_planes_pensiones, :valor_coches_vehiculos,
            :valor_otros_activos, :hipoteca_inmuebles,
            :deuda_tarjeta_credito, :prestamos_personales,
            :prestamos_coches, :otras_deudas,
            numericality: { only_integer: true, greater_than_or_equal_to: 0, message: "Los valores no pueden ser negativos" }

  # Check if Balance has real data (sum of assets + debts > 0)
  def has_data?
    total_activos = (valor_inmuebles || 0) +
                    (dinero_cuenta_corriente || 0) +
                    (dinero_cuenta_ahorro_depos || 0) +
                    (dinero_inversiones_f || 0) +
                    (dinero_planes_pensiones || 0) +
                    (valor_coches_vehiculos || 0) +
                    (valor_otros_activos || 0)

    total_deudas = (hipoteca_inmuebles || 0) +
                   (deuda_tarjeta_credito || 0) +
                   (prestamos_personales || 0) +
                   (prestamos_coches || 0) +
                   (otras_deudas || 0)

    (total_activos + total_deudas) > 0
  end

  private

  def zeros_en_blanco
    %i[
      valor_inmuebles dinero_cuenta_corriente dinero_cuenta_ahorro_depos
      dinero_inversiones_f dinero_planes_pensiones valor_coches_vehiculos
      valor_otros_activos hipoteca_inmuebles deuda_tarjeta_credito
      prestamos_personales prestamos_coches otras_deudas
    ].each do |attr|
      self[attr] = 0 if self[attr].blank?
    end
  end
end
