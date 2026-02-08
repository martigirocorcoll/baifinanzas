# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

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
puts "🎉 Seeding completed!"
