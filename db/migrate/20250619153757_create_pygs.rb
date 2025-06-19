class CreatePygs < ActiveRecord::Migration[7.2]
  def change
    create_table :pygs do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :ingresos_mensual
      t.integer :gasto_compra
      t.integer :alquiler_hipoteca
      t.integer :gastos_utilities
      t.integer :gastos_seguros
      t.integer :gastos_transporte
      t.integer :restaurantes_y_ocio
      t.integer :cuota_hipoteca
      t.integer :cuota_coche
      t.integer :otras_cuotas
      t.integer :suscripciones
      t.integer :cuidado_personal
      t.integer :otros_gastos

      t.timestamps
    end
  end
end
