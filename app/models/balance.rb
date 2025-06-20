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
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

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
