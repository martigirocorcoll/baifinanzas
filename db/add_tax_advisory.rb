# Crear recomendación de asesoramiento fiscal y sucesorio

tax_advisory_data = {
  slug: "tax_advisory",
  title: "Asesoramiento Fiscal y Sucesorio",
  description: "Asesoramiento especializado en optimización fiscal y planificación sucesoria para patrimonios de alto nivel.",
  content: "Con libertad financiera alcanzada, la optimización fiscal y la planificación sucesoria se vuelven fundamentales para preservar y transmitir tu patrimonio eficientemente.\n\n**Optimización Fiscal Avanzada:**\n- **Planificación fiscal anual:** Estrategias para minimizar la carga tributaria\n- **Estructuras societarias:** Evaluar si conviene patrimonial vs personal\n- **Inversiones fiscalmente eficientes:** Aprovechar deducciones y exenciones\n- **Residencia fiscal:** Optimización según tu situación personal\n- **Diferimiento fiscal:** Estrategias de aplazamiento de tributación\n\n**Planificación Sucesoria:**\n- **Testamento optimizado:** Estructuración eficaz de la herencia\n- **Seguros de vida:** Cobertura para impuestos sucesorios\n- **Donaciones en vida:** Estrategias de transmisión anticipada\n- **Estructuras familiares:** Holdings familiares y otras figuras\n- **Protección patrimonial:** Blindaje ante contingencias\n\n**¿Por qué es crucial en tu nivel?**\n- Los impuestos pueden ser tu mayor 'gasto' anual\n- Errores de planificación cuestan decenas de miles de euros\n- La transmisión ineficiente puede reducir el patrimonio en 30-50%\n- Regulaciones complejas requieren especialización\n\n**Servicios especializados:**\n- **Asesor fiscal especializado en patrimonios**\n- **Abogado especialista en sucesiones**\n- **Family office** (para patrimonios >2M€)\n- **Planificador patrimonial integral**\n\n**Revisiones recomendadas:**\n- **Anual:** Planificación fiscal del ejercicio\n- **Cada 3 años:** Revisión integral de estructuras\n- **Cambios vitales:** Matrimonio, hijos, jubilación\n- **Cambios normativos:** Adaptación a nuevas leyes\n\n**¿Cuándo es urgente?**\n- Patrimonio superior a 400.000€ (umbral sucesorio)\n- Ingresos anuales superiores a 60.000€\n- Tienes activos en múltiples países\n- Planeas transmitir patrimonio a hijos\n- Tienes estructuras empresariales complejas",
  category: "fiscal",
  active: true
}

# Crear o actualizar la recomendación
recommendation = Recommendation.find_or_initialize_by(slug: tax_advisory_data[:slug])
recommendation.assign_attributes(tax_advisory_data)

if recommendation.save
  puts "✅ Recomendación creada/actualizada: #{recommendation.title}"
else
  puts "❌ Error creando #{tax_advisory_data[:slug]}: #{recommendation.errors.full_messages.join(', ')}"
end

puts "\n🎉 Asesoramiento fiscal añadido!"