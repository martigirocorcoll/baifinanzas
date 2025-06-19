class CreateBalances < ActiveRecord::Migration[7.2]
  def change
    create_table :balances do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :valor_inmuebles
      t.integer :dinero_cuenta_corriente
      t.integer :dinero_cuenta_ahorro_depos
      t.integer :dinero_inversiones_f
      t.integer :dinero_planes_pensiones
      t.integer :valor_coches_vehiculos
      t.integer :valor_otros_activos
      t.integer :hipoteca_inmuebles
      t.integer :deuda_tarjeta_credito
      t.integer :prestamos_personales
      t.integer :prestamos_coches
      t.integer :otras_deudas

      t.timestamps
    end
  end
end
