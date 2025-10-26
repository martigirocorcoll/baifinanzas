# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Clear existing recommendations (but keep influencers as they may be referenced by users)
Recommendation.destroy_all

puts "✅ Recommendations cleared"

# Create default influencer for testing (if doesn't exist)
puts "🌱 Ensuring default influencer exists..."

Influencer.find_or_create_by!(email: "influencer@demo.com") do |inf|
  inf.name = "Influencer Demo"
  inf.password = "password123"
  inf.ac_compte = "https://ejemplo.com/cuenta"
  inf.ac_cdiposit = "https://ejemplo.com/deposito"
  inf.ac_curt = "https://ejemplo.com/inversion-corto"
  inf.ac_llarg = "https://ejemplo.com/inversion-largo"
  inf.ac_deute = "https://ejemplo.com/deudas"
  inf.ac_jubil = "https://ejemplo.com/pension"
  inf.ac_fiscal = "https://ejemplo.com/fiscal"
end

puts "✅ Default influencer ready"

# Create recommendations
puts "🌱 Creating recommendations..."

Recommendation.create!(
  slug: "better-bank-account",
  title: "Ten una mejor cuenta bancaria",
  description: "Elimina las comisiones bancarias y optimiza el rendimiento de tu dinero en cuenta corriente. Una cuenta optimizada te ayuda a empezar con el pie correcto, es el paso más sencillo que puedes dar sin ningún tipo de riesgo y te enfoca a empezar el camino para mejorar tu situación financiera.",
  active: true
)

Recommendation.create!(
  slug: "emergency-deposit",
  title: "Construye tu fondo de emergencia",
  description: "Protege tu estabilidad financiera con un colchón de seguridad que te dé tranquilidad ante imprevistos. Un fondo de emergencia bien estructurado es la base de cualquier plan financiero sólido.",
  active: true
)

puts "✅ Successfully created #{Recommendation.count} recommendations"
puts "🎉 Seeding completed!"
