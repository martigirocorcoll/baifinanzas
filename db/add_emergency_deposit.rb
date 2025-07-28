# Crear recomendación de depósito para fondo de emergencia

emergency_deposit_data = {
  slug: "emergency_deposit",
  title: "Depósito para Fondo de Emergencia",
  description: "Depósito bancario específico para construir tu colchón de seguridad financiera con mayor rentabilidad que una cuenta corriente.",
  content: "Un depósito para tu fondo de emergencia te ofrece la combinación perfecta de seguridad, liquidez y rentabilidad para tu colchón financiero.\n\n**¿Por qué un depósito y no una cuenta corriente?**\n- **Mayor rentabilidad:** Entre 1.5-3% vs 0% de cuenta corriente\n- **Seguridad total:** Garantizado por el Fondo de Garantía de Depósitos hasta 100.000€\n- **Liquidez controlada:** Acceso a tu dinero cuando realmente lo necesites\n- **Separación mental:** No lo confundes con dinero para gastos\n\n**Características del depósito ideal:**\n- Sin comisiones de apertura o mantenimiento\n- Cancelación anticipada sin penalización (o muy baja)\n- Renovación automática opcional\n- Acceso online para seguimiento\n\n**¿Cuánto depositar?**\n- **Mínimo:** 3 meses de gastos básicos\n- **Recomendado:** 4-6 meses de gastos totales\n- **Estrategia:** Empieza con 1 mes, ve incrementando gradualmente\n\n**Plazos recomendados:**\n- **3-6 meses:** Balance perfecto liquidez/rentabilidad\n- **Evitar:** Plazos superiores a 12 meses (limita acceso)\n- **Tip:** Escalonar vencimientos (parte a 3 meses, parte a 6)\n\n**Construcción del fondo:**\n1. Calcula tus gastos mensuales esenciales\n2. Multiplica por 3-6 meses según tu estabilidad laboral\n3. Divide la cantidad objetivo entre 12-24 meses\n4. Automatiza esa transferencia mensual al depósito\n\n**¿Cuándo NO usar el fondo?**\n- Vacaciones o caprichos\n- Inversiones u oportunidades\n- Gastos que puedes planificar\n- Solo para: pérdida empleo, emergencias médicas, reparaciones esenciales",
  category: "depositos",
  active: true
}

# Crear o actualizar la recomendación
recommendation = Recommendation.find_or_initialize_by(slug: emergency_deposit_data[:slug])
recommendation.assign_attributes(emergency_deposit_data)

if recommendation.save
  puts "✅ Recomendación creada/actualizada: #{recommendation.title}"
else
  puts "❌ Error creando #{emergency_deposit_data[:slug]}: #{recommendation.errors.full_messages.join(', ')}"
end

puts "\n🎉 Depósito de emergencia añadido!"