# Test script for financial engine

# Create or find test user
user = User.find_or_create_by(email: "test@example.com") do |u|
  u.password = "123456"
end
puts "✅ User created: #{user.email}"

# Test with default empty financial data
puts "\n=== TEST 1: Empty Financial Data ==="
puts "Financial health level: #{user.financial_health_level}"
puts "Monthly cash flow: #{user.monthly_cash_flow}"
puts "Net worth: #{user.net_worth}"
puts "Recommendations: #{user.financial_recommendations}"

# Update with some basic financial data
puts "\n=== TEST 2: Basic Financial Data ==="
user.pyg.update!(
  ingresos_mensual: 3000,
  gasto_compra: 400,
  alquiler_hipoteca: 800,
  gastos_utilities: 150,
  restaurantes_y_ocio: 300,
  otros_gastos: 200
)

user.balance.update!(
  dinero_cuenta_corriente: 1500,
  dinero_cuenta_ahorro_depos: 5000,
  deuda_tarjeta_credito: 2000
)

puts "Financial health level: #{user.financial_health_level}"
puts "Monthly income: #{user.monthly_income}"
puts "Monthly expenses: #{user.monthly_expenses}"
puts "Monthly cash flow: #{user.monthly_cash_flow}"
puts "Emergency fund target: #{user.emergency_fund_target}"
puts "Has emergency fund?: #{user.has_emergency_fund?}"
puts "Expensive debt: #{user.expensive_debt}"
puts "Recommendations: #{user.financial_recommendations}"

# Test objectives
puts "\n=== TEST 3: Adding Objectives ==="
objective = user.objectives.create!(
  title: "Vacaciones en Europa",
  target_amount: 5000,
  target_date: 2.years.from_now,
  status: "active"
)

puts "Objective: #{objective.title}"
puts "Years to target: #{objective.years_to_target}"
puts "Investment recommendation: #{objective.investment_recommendation}"
puts "Monthly savings needed: #{objective.monthly_savings_needed}"
puts "Savings capacity analysis: #{objective.savings_capacity_analysis}"

# Test with better financial position
puts "\n=== TEST 4: Better Financial Position ==="
user.balance.update!(
  dinero_cuenta_corriente: 5000,
  dinero_cuenta_ahorro_depos: 15000,
  deuda_tarjeta_credito: 0,
  dinero_inversiones_f: 10000
)

puts "Financial health level: #{user.financial_health_level}"
puts "Net worth: #{user.net_worth}"
puts "Has emergency fund?: #{user.has_emergency_fund?}"
puts "Recommendations: #{user.financial_recommendations}"

puts "\n=== Test Complete ==="