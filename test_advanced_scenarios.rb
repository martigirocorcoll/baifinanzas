# Test advanced scenarios

# Use existing user
user = User.find_by(email: "test@example.com")

puts "=== TEST 1: Multiple Objectives ==="

# Add retirement objective
retirement = user.objectives.create!(
  title: "Plan de jubilación",
  target_amount: 300000,
  target_date: 25.years.from_now,
  status: "active"
)

# Add short-term objective
vacation = user.objectives.create!(
  title: "Vacaciones",
  target_amount: 3000,
  target_date: 1.year.from_now,
  status: "active"
)

puts "Retirement objective:"
puts "  Investment recommendation: #{retirement.investment_recommendation}"
puts "  Monthly savings needed: €#{retirement.monthly_savings_needed}"
puts "  Annual return rate: #{(retirement.annual_return_rate * 100).round(1)}%"

puts "\nVacation objective:"
puts "  Investment recommendation: #{vacation.investment_recommendation}"
puts "  Monthly savings needed: €#{vacation.monthly_savings_needed}"
puts "  Annual return rate: #{(vacation.annual_return_rate * 100).round(1)}%"

puts "\nUser recommendations: #{user.financial_recommendations}"

puts "\n=== TEST 2: Different Financial Health Levels ==="

# Test "Iniciando" level
user.pyg.update!(ingresos_mensual: 1500)
user.balance.update!(
  dinero_cuenta_corriente: 100,
  dinero_cuenta_ahorro_depos: 200,
  deuda_tarjeta_credito: 5000
)
puts "Iniciando level:"
puts "  Cash flow: €#{user.monthly_cash_flow}"
puts "  Health level: #{user.financial_health_level}"
puts "  Recommendations: #{user.financial_recommendations}"

# Test "Acomodado" level
user.pyg.update!(ingresos_mensual: 5000)
user.balance.update!(
  dinero_cuenta_corriente: 20000,
  dinero_cuenta_ahorro_depos: 50000,
  dinero_inversiones_f: 100000,
  valor_inmuebles: 200000,
  deuda_tarjeta_credito: 0,
  hipoteca_inmuebles: 100000
)
puts "\nAcomodado level:"
puts "  Net worth: €#{user.net_worth}"
puts "  Debt-free?: #{user.is_debt_free?}"
puts "  Health level: #{user.financial_health_level}"
puts "  Recommendations: #{user.financial_recommendations}"

# Test "Libertad Financiera"
user.balance.update!(
  dinero_inversiones_f: 500000,
  valor_inmuebles: 800000,
  hipoteca_inmuebles: 0
)
puts "\nLibertad Financiera level:"
puts "  Investment income: €#{user.investment_income_monthly}/month"
puts "  Monthly expenses: €#{user.monthly_expenses}/month"
puts "  Has financial freedom?: #{user.has_financial_freedom?}"
puts "  Health level: #{user.financial_health_level}"
puts "  Recommendations: #{user.financial_recommendations}"

puts "\n=== TEST 3: Insufficient Savings Capacity ==="

# Create expensive objective with low income
user.pyg.update!(ingresos_mensual: 2000)
user.balance.update!(
  dinero_cuenta_corriente: 1000,
  dinero_cuenta_ahorro_depos: 2000,
  dinero_inversiones_f: 0,
  valor_inmuebles: 0
)

expensive_goal = user.objectives.create!(
  title: "Casa nueva",
  target_amount: 100000,
  target_date: 3.years.from_now,
  status: "active"
)

analysis = expensive_goal.savings_capacity_analysis
puts "Expensive goal analysis:"
puts "  Monthly needed: €#{analysis[:monthly_needed]}"
puts "  Available cash flow: €#{analysis[:available_cash_flow]}"
puts "  Sufficient capacity?: #{analysis[:sufficient]}"
if !analysis[:sufficient]
  puts "  Deficit: €#{analysis[:deficit]}"
end

puts "\n=== TEST 4: Affiliate Links ==="

# Create influencer and associate with user
influencer = Influencer.create!(
  name: "Test Influencer",
  ac_compte: "https://bank.com/ref123",
  ac_cdiposit: "https://deposit.com/ref123",
  ac_curt: "https://shortterm.com/ref123",
  ac_llarg: "https://longterm.com/ref123",
  ac_jubil: "https://retirement.com/ref123",
  ac_deute: "https://debthelp.com/ref123"
)

user.update!(influencer: influencer)

puts "Recommendations with affiliate links:"
user.recommendations_with_links.each do |rec|
  puts "  #{rec[:product]}: #{rec[:affiliate_link] || 'No link'}"
end

puts "\n=== All Tests Complete ==="