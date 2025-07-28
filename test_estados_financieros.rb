#!/usr/bin/env ruby
require_relative 'config/environment'

def crear_usuario_prueba(nombre, pyg_data, balance_data)
  puts "\n" + "="*60
  puts "🧪 PROBANDO: #{nombre}"
  puts "="*60
  
  # Crear usuario temporal
  user = User.new(email: "test@example.com")
  
  # Crear PYG temporal
  pyg = Pyg.new(pyg_data)
  user.define_singleton_method(:pyg) { pyg }
  
  # Crear Balance temporal  
  balance = Balance.new(balance_data)
  user.define_singleton_method(:balance) { balance }
  
  # Mostrar datos clave
  puts "💰 Ingresos mensuales: €#{user.monthly_income.to_i}"
  puts "💸 Gastos mensuales: €#{user.monthly_expenses.to_i}"
  puts "📈 Cash flow: €#{user.monthly_cash_flow.to_i}"
  puts "🏦 Activos líquidos: €#{user.liquid_assets.to_i}"
  puts "🏠 Patrimonio neto: €#{user.net_worth.to_i}"
  puts "💳 Deuda cara: €#{user.expensive_debt.to_i}"
  puts "📊 Ratio deuda cara/patrimonio: #{(user.expensive_debt_ratio * 100).round(1)}%"
  puts "🎯 Colchón 4 meses: €#{user.emergency_fund_target.to_i} (¿tiene? #{user.has_emergency_fund? ? '✅' : '❌'})"
  puts "🎯 Colchón 2 meses: €#{user.monthly_expenses * 2} (¿tiene? #{user.has_partial_emergency_fund? ? '✅' : '❌'})"
  puts "💼 Ingresos inversión: €#{user.investment_income_monthly.round(2)}/mes"
  
  estado = user.financial_health_level
  puts "\n🏆 ESTADO CLASIFICADO: #{estado}"
  
  return user
end

# ESCENARIO 1: Persona empezando (cash flow negativo)
crear_usuario_prueba("Estudiante sin ingresos",
  { ingresos_mensual: 800, gasto_compra: 400, alquiler_hipoteca: 600, gastos_utilities: 100, 
    gastos_seguros: 0, gastos_transporte: 50, restaurantes_y_ocio: 150, cuota_hipoteca: 0, 
    cuota_coche: 0, otras_cuotas: 0, suscripciones: 30, cuidado_personal: 50, otros_gastos: 50 },
  { valor_inmuebles: 0, dinero_cuenta_corriente: 500, dinero_cuenta_ahorro_depos: 1000, 
    dinero_inversiones_f: 0, dinero_planes_pensiones: 0, valor_coches_vehiculos: 2000, 
    valor_otros_activos: 500, hipoteca_inmuebles: 0, deuda_tarjeta_credito: 2000, 
    prestamos_personales: 0, prestamos_coches: 0, otras_deudas: 0 }
)

# ESCENARIO 2: Construyendo base (cash flow positivo, sin colchón)
crear_usuario_prueba("Joven profesional ahorrando",
  { ingresos_mensual: 2500, gasto_compra: 400, alquiler_hipoteca: 800, gastos_utilities: 120, 
    gastos_seguros: 50, gastos_transporte: 100, restaurantes_y_ocio: 300, cuota_hipoteca: 0, 
    cuota_coche: 200, otras_cuotas: 0, suscripciones: 50, cuidado_personal: 80, otros_gastos: 100 },
  { valor_inmuebles: 0, dinero_cuenta_corriente: 1000, dinero_cuenta_ahorro_depos: 2000, 
    dinero_inversiones_f: 1000, dinero_planes_pensiones: 5000, valor_coches_vehiculos: 8000, 
    valor_otros_activos: 1000, hipoteca_inmuebles: 0, deuda_tarjeta_credito: 1500, 
    prestamos_personales: 0, prestamos_coches: 6000, otras_deudas: 0 }
)

# ESCENARIO 3: Liberándose de deudas (colchón 2 meses, deuda cara alta)
crear_usuario_prueba("Profesional con deudas altas",
  { ingresos_mensual: 4000, gasto_compra: 600, alquiler_hipoteca: 1200, gastos_utilities: 150, 
    gastos_seguros: 80, gastos_transporte: 150, restaurantes_y_ocio: 400, cuota_hipoteca: 0, 
    cuota_coche: 300, otras_cuotas: 100, suscripciones: 80, cuidado_personal: 100, otros_gastos: 150 },
  { valor_inmuebles: 0, dinero_cuenta_corriente: 3000, dinero_cuenta_ahorro_depos: 4000, 
    dinero_inversiones_f: 2000, dinero_planes_pensiones: 15000, valor_coches_vehiculos: 15000, 
    valor_otros_activos: 2000, hipoteca_inmuebles: 0, deuda_tarjeta_credito: 8000, 
    prestamos_personales: 5000, prestamos_coches: 12000, otras_deudas: 0 }
)

# ESCENARIO 4: Invirtiendo en objetivos (colchón 4 meses, poca deuda cara)
crear_usuario_prueba("Profesional estable invirtiendo",
  { ingresos_mensual: 5000, gasto_compra: 800, alquiler_hipoteca: 1500, gastos_utilities: 200, 
    gastos_seguros: 100, gastos_transporte: 200, restaurantes_y_ocio: 500, cuota_hipoteca: 0, 
    cuota_coche: 400, otras_cuotas: 50, suscripciones: 100, cuidado_personal: 150, otros_gastos: 200 },
  { valor_inmuebles: 0, dinero_cuenta_corriente: 5000, dinero_cuenta_ahorro_depos: 10000, 
    dinero_inversiones_f: 15000, dinero_planes_pensiones: 30000, valor_coches_vehiculos: 20000, 
    valor_otros_activos: 5000, hipoteca_inmuebles: 0, deuda_tarjeta_credito: 2000, 
    prestamos_personales: 0, prestamos_coches: 15000, otras_deudas: 0 }
)

# ESCENARIO 5: Acomodado (colchón + patrimonio 2 años ingresos)
crear_usuario_prueba("Ejecutivo acomodado",
  { ingresos_mensual: 8000, gasto_compra: 1000, alquiler_hipoteca: 2000, gastos_utilities: 250, 
    gastos_seguros: 150, gastos_transporte: 300, restaurantes_y_ocio: 800, cuota_hipoteca: 0, 
    cuota_coche: 500, otras_cuotas: 100, suscripciones: 150, cuidado_personal: 200, otros_gastos: 300 },
  { valor_inmuebles: 300000, dinero_cuenta_corriente: 10000, dinero_cuenta_ahorro_depos: 20000, 
    dinero_inversiones_f: 50000, dinero_planes_pensiones: 80000, valor_coches_vehiculos: 30000, 
    valor_otros_activos: 10000, hipoteca_inmuebles: 250000, deuda_tarjeta_credito: 0, 
    prestamos_personales: 0, prestamos_coches: 20000, otras_deudas: 0 }
)

# ESCENARIO 6: Libertad financiera (ingresos inversión > gastos)
crear_usuario_prueba("Jubilado con libertad financiera",
  { ingresos_mensual: 3000, gasto_compra: 600, alquiler_hipoteca: 0, gastos_utilities: 200, 
    gastos_seguros: 100, gastos_transporte: 150, restaurantes_y_ocio: 400, cuota_hipoteca: 0, 
    cuota_coche: 0, otras_cuotas: 0, suscripciones: 100, cuidado_personal: 150, otros_gastos: 200 },
  { valor_inmuebles: 500000, dinero_cuenta_corriente: 20000, dinero_cuenta_ahorro_depos: 50000, 
    dinero_inversiones_f: 400000, dinero_planes_pensiones: 300000, valor_coches_vehiculos: 15000, 
    valor_otros_activos: 20000, hipoteca_inmuebles: 0, deuda_tarjeta_credito: 0, 
    prestamos_personales: 0, prestamos_coches: 0, otras_deudas: 0 }
)

puts "\n" + "="*60
puts "✅ PRUEBAS COMPLETADAS"
puts "="*60