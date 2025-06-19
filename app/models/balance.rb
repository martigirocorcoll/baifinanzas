class Balance < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true

  validates :valor_inmuebles, :dinero_cuenta_corriente, :dinero_cuenta_ahorro_depos,
            :dinero_inversiones_f, :dinero_planes_pensiones,
            :valor_coches_vehiculos, :valor_otros_activos,
            :hipoteca_inmuebles, :deuda_tarjeta_credito,
            :prestamos_personales, :prestamos_coches, :otras_deudas,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
