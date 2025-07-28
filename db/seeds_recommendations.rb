# Seeds para las recomendaciones ampliadas

# Recomendaciones de objetivos (basadas en investment_recommendation)
recommendations_data = [
  {
    slug: "ac_diposit",
    title: "Depósito a Corto Plazo",
    description: "Producto financiero ideal para objetivos a corto plazo (menos de 2 años) que prioriza la seguridad y liquidez por encima de la rentabilidad.",
    content: "Los depósitos a corto plazo son la opción más segura para tus objetivos inmediatos. Con una rentabilidad aproximada del 1.5% anual, garantizan que tu dinero esté disponible cuando lo necesites sin riesgo de pérdidas.\n\n**Ventajas principales:**\n- Garantía total del capital invertido\n- Liquidez inmediata o a muy corto plazo\n- Sin comisiones de gestión\n- Rentabilidad fija y predecible\n\n**¿Cuándo es recomendable?**\nEste producto es perfecto cuando tu objetivo está a menos de 2 años y no puedes permitirte ningún riesgo de pérdida del capital. La estabilidad es más importante que la rentabilidad máxima.",
    category: "depositos",
    active: true
  },
  {
    slug: "ac_curt",
    title: "Fondo de Inversión Conservador",
    description: "Fondo de inversión con perfil conservador-moderado, diseñado para objetivos a medio plazo (2-5 años) con equilibrio entre seguridad y rentabilidad.",
    content: "Los fondos de inversión conservadores ofrecen un equilibrio óptimo entre seguridad y rentabilidad para tus objetivos a medio plazo. Con una rentabilidad esperada del 3% anual, diversifican el riesgo invirtiendo en una mezcla de renta fija y variable.\n\n**Características principales:**\n- Rentabilidad esperada: ~3% anual\n- Diversificación automática del riesgo\n- Gestión profesional del fondo\n- Liquidez en pocos días hábiles\n- Perfil de riesgo conservador-moderado\n\n**Composición típica:**\n- 70% Renta Fija (bonos y obligaciones)\n- 30% Renta Variable (acciones seleccionadas)\n\n**¿Por qué para objetivos de 2-5 años?**\nEste horizonte temporal permite absorber pequeñas fluctuaciones del mercado mientras se beneficia del potencial de crecimiento de la renta variable.",
    category: "fondos",
    active: true
  },
  {
    slug: "ac_llarg",
    title: "Fondo de Inversión Crecimiento",
    description: "Fondo de inversión orientado al crecimiento a largo plazo, ideal para objetivos superiores a 5 años que buscan maximizar la rentabilidad.",
    content: "Los fondos de crecimiento están diseñados para maximizar tu rentabilidad a largo plazo. Con una rentabilidad esperada del 8% anual, son ideales cuando tienes más de 5 años para alcanzar tu objetivo y puedes asumir cierta volatilidad.\n\n**Características principales:**\n- Rentabilidad esperada: ~8% anual\n- Exposición principal a renta variable internacional\n- Gestión activa y estratégica\n- Horizonte de inversión recomendado: +5 años\n- Mayor potencial de crecimiento\n\n**Composición típica:**\n- 80% Renta Variable (acciones globales)\n- 20% Renta Fija (para estabilidad)\n\n**¿Por qué funciona a largo plazo?**\nLa historia demuestra que los mercados de renta variable, a pesar de su volatilidad a corto plazo, han proporcionado las mejores rentabilidades a largo plazo. El tiempo es tu aliado para suavizar las fluctuaciones.",
    category: "fondos",
    active: true
  },
  {
    slug: "ac_jubil",
    title: "Plan de Pensiones Crecimiento",
    description: "Plan de pensiones diseñado específicamente para la jubilación, con ventajas fiscales y estrategia de crecimiento a muy largo plazo.",
    content: "Los planes de pensiones de crecimiento combinan las ventajas fiscales de la jubilación con una estrategia de inversión orientada al largo plazo. Con una rentabilidad esperada del 8% anual y importantes beneficios fiscales.\n\n**Ventajas específicas para jubilación:**\n- Deducción fiscal anual hasta 1.500€\n- Rentabilidad esperada: ~8% anual\n- Gestión especializada en jubilación\n- Fiscalidad diferida hasta el rescate\n- Estrategia adaptada a tu edad\n\n**Estrategia por edades:**\n- **Jóvenes (20-40 años):** 90% renta variable\n- **Maduros (40-55 años):** 70% renta variable\n- **Pre-jubilación (55+ años):** 50% renta variable\n\n**¿Por qué es especial?**\nAdemás de la rentabilidad, cada euro aportado reduce tu base imponible del IRPF, generando un ahorro fiscal inmediato que potencia tu ahorro para la jubilación.",
    category: "planes_pensiones",
    active: true
  }
]

# Recomendaciones base (genéricas según estado financiero)
base_recommendations = [
  {
    slug: "cuenta-ahorro-basica",
    title: "Cuenta de Ahorro Remunerada",
    description: "Cuenta de ahorro con interés para empezar a hacer crecer tu dinero de forma segura.",
    content: "Una cuenta de ahorro remunerada es el primer paso para optimizar tus finanzas. Te permite ganar intereses sobre tu dinero mientras mantienes total liquidez.\n\n**Beneficios principales:**\n- Interés sobre tu saldo\n- Disponibilidad inmediata del dinero\n- Sin riesgo de pérdidas\n- Sin comisiones de mantenimiento\n- Perfecto para tu fondo de emergencia\n\n**¿Cuándo es recomendable?**\nIdeal para personas que están empezando a organizar sus finanzas y necesitan un lugar seguro donde aparcar sus ahorros mientras generan una pequeña rentabilidad.",
    category: "cuentas",
    active: true
  },
  {
    slug: "fondo-emergencia",
    title: "Fondo de Emergencia",
    description: "Estrategia para construir un colchón financiero que te proteja ante imprevistos.",
    content: "El fondo de emergencia es la base de cualquier estrategia financiera sólida. Debe cubrir entre 3-6 meses de tus gastos fijos y estar disponible inmediatamente.\n\n**¿Cuánto necesitas?**\n- Mínimo: 3 meses de gastos fijos\n- Recomendado: 6 meses de gastos fijos\n- Para autónomos: 6-12 meses\n\n**¿Dónde guardarlo?**\n- Cuenta de ahorro remunerada\n- Depósito a la vista\n- Fondo monetario (máxima liquidez)\n\n**¿Por qué es importante?**\nTe permite afrontar imprevistos (pérdida de empleo, gastos médicos, reparaciones) sin recurrir a deudas caras o vender inversiones en mal momento.",
    category: "emergencia",
    active: true
  }
]

# Crear todas las recomendaciones
all_recommendations = recommendations_data + base_recommendations

all_recommendations.each do |rec_data|
  recommendation = Recommendation.find_or_initialize_by(slug: rec_data[:slug])
  recommendation.assign_attributes(rec_data)
  
  if recommendation.save
    puts "✅ Recomendación creada/actualizada: #{recommendation.title}"
  else
    puts "❌ Error creando #{rec_data[:slug]}: #{recommendation.errors.full_messages.join(', ')}"
  end
end

puts "\n🎉 Seeds de recomendaciones completados!"
puts "Total recomendaciones: #{Recommendation.count}"