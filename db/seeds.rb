# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding recommendations..."

# Clear existing recommendations
Recommendation.destroy_all

# ============================
# VALLE PROFUNDO - Iniciando
# ============================

Recommendation.create!(
  slug: "saving_advice",
  title: "Plan de Ahorro Personalizado",
  description: "Transforma tu situación financiera con estrategias probadas para crear tu primer colchón de ahorro",
  content: "## Tu situación actual requiere acción inmediata

Sabemos que cuando los gastos igualan o superan los ingresos, cada euro cuenta. Por eso hemos diseñado un plan específico para tu situación.

### 🎯 Objetivo inmediato: Crear tu primer colchón de 500€

**Semana 1-2: Auditoría de gastos**
- Cancela 3 suscripciones que no uses (ahorro medio: 30€/mes)
- Revisa tu tarifa móvil y luz (ahorro medio: 20€/mes)
- Identifica gastos hormiga diarios (café, snacks: 40€/mes)

**Semana 3-4: Implementación del sistema**
- Abre una cuenta de ahorro separada (sin tarjeta asociada)
- Configura transferencia automática de 50€ el día 1 de cada mes
- Usa la regla 24 horas: espera un día antes de cualquier compra no esencial

**Mes 2-3: Aceleración**
- Vende 5 cosas que no uses (objetivo: 100€ extra)
- Negocia un ingreso extra o horas extra (objetivo: 150€/mes)
- Implementa un día sin gastos a la semana

### 💰 Resultados esperados
- Mes 1: 50-80€ ahorrados
- Mes 3: 200-300€ acumulados
- Mes 6: 500-800€ = Tu primer fondo de emergencia

### 📊 Herramientas gratuitas incluidas
- Plantilla de control de gastos Excel
- Calculadora de ahorro personalizada
- Recordatorios automáticos de objetivos

### ⚡ Acción inmediata requerida
El 67% de las personas que empiezan HOY consiguen su objetivo. Las que lo dejan para mañana solo lo logran en un 23% de los casos.",
  active: true
)

Recommendation.create!(
  slug: "better_bank_account",
  title: "Cuenta Bancaria Sin Comisiones",
  description: "Deja de pagar por tu dinero - Ahorra hasta 240€/año en comisiones bancarias",
  content: "## Las comisiones bancarias están devorando tus ahorros

El banco medio en España cobra 240€/año en comisiones. Ese dinero debería estar en tu bolsillo.

### 🚫 Comisiones que estás pagando (y no deberías)
- Mantenimiento de cuenta: 60-120€/año
- Tarjeta de débito: 20-40€/año
- Transferencias: 3-5€ cada una
- Retiradas en cajeros: 2-4€ por operación
- Comisión por descubierto: 30€ + intereses

### ✅ Lo que obtienes con una cuenta optimizada
**Sin comisiones:**
- Cuenta y tarjeta 100% gratuitas
- Transferencias ilimitadas sin coste
- Sin comisión por mantenimiento
- Retiradas gratis en 40.000+ cajeros

**Beneficios adicionales:**
- Tarjeta virtual instantánea para compras online seguras
- Control de gastos en tiempo real desde la app
- Categorización automática de gastos
- Alertas de movimientos sospechosos

### 💡 Caso real: María, 28 años
*'Cambié de banco hace 6 meses. He ahorrado 180€ en comisiones y además tengo mejor app para controlar mis gastos. El cambio me llevó 15 minutos online.'*

### 📱 Proceso de cambio (15 minutos)
1. **Apertura online** - Sin papeleos, desde el móvil
2. **Verificación** - Con videollamada o foto del DNI
3. **Activación** - Cuenta operativa en 24-48h
4. **Traspaso** - El nuevo banco gestiona el cambio de domiciliaciones

### ⏰ Momento perfecto para cambiar
- Inicio de mes = Mejor control del cambio
- Antes de que te cobren la próxima comisión
- Aprovecha las promociones actuales de bienvenida

### 🎁 Bonus por apertura
Muchos bancos online ofrecen entre 50-150€ de regalo por abrir cuenta y domiciliar nómina. Es dinero gratis que suma a tu fondo de emergencia.",
  active: true
)

Recommendation.create!(
  slug: "debt_review",
  title: "Análisis y Reducción de Deudas",
  description: "Plan estratégico para eliminar tus deudas hasta 40% más rápido y ahorrar miles de euros en intereses",
  content: "## Tus deudas te están costando más de lo que crees

Cada mes que pasa, los intereses se acumulan. Vamos a parar esta espiral AHORA.

### 📊 Diagnóstico de tu situación
**Deudas de alto coste (eliminar primero):**
- Tarjetas de crédito: 18-25% TAE
- Microcréditos: 20-30% TAE
- Descubiertos: 15-20% TAE + comisiones

**Deudas de coste medio:**
- Préstamos personales: 7-12% TAE
- Financiación de compras: 10-15% TAE

### 🎯 Estrategia de eliminación: Método Avalancha Optimizado

**Paso 1: Negociación inmediata (Semana 1)**
- Llama a cada acreedor y negocia el tipo de interés
- Solicita reunificación de deudas con tu banco
- Éxito medio: Reducción del 15-30% en intereses

**Paso 2: Plan de ataque (Mes 1-6)**
1. Lista todas tus deudas de mayor a menor interés
2. Paga mínimos en todas excepto la de mayor interés
3. Ataca con todo lo extra la deuda más cara
4. Una vez eliminada, pasa a la siguiente

**Paso 3: Aceleración (Mes 6+)**
- Usa cualquier ingreso extra para deudas (pagas extra, devolución hacienda)
- Vende lo que no necesites y aplícalo a deudas
- Considera un trabajo temporal para acelerar

### 💰 Ejemplo real de ahorro
**Situación inicial:**
- Tarjeta crédito: 3.000€ al 20% = 600€/año en intereses
- Préstamo personal: 5.000€ al 8% = 400€/año
- Total intereses: 1.000€/año

**Con estrategia optimizada:**
- Negociación reduce intereses a 750€/año
- Eliminación acelerada ahorra 6 meses de pagos
- **Ahorro total: 1.500€ en 18 meses**

### 🚀 Herramientas de apoyo
- Calculadora de estrategia de deudas personalizada
- Plantilla de negociación con acreedores
- Seguimiento mensual de progreso
- Grupo de apoyo y motivación

### ⚠️ Errores que debes evitar
- NO pagues solo mínimos (tardarías 25 años en liquidar)
- NO ignores las deudas (crecen exponencialmente)
- NO pidas más préstamos para pagar préstamos
- NO te rindas (el 73% abandona en el mes 3)

### 🎯 Tu objetivo para los próximos 30 días
1. Completa el análisis de todas tus deudas
2. Negocia al menos una reducción de interés
3. Elimina la deuda más pequeña para ganar momentum
4. Celebra cada victoria (sin gastar dinero)",
  active: true
)

# ============================
# CAMPO BASE - Construyendo Base
# ============================

Recommendation.create!(
  slug: "emergency_deposit",
  title: "Depósito Fondo de Emergencia",
  description: "Construye tu red de seguridad financiera con rentabilidad garantizada y disponibilidad inmediata",
  content: "## Tu fondo de emergencia: La base de tu libertad financiera

Has dado el primer paso. Ahora vamos a blindar tu futuro con un fondo de emergencia sólido.

### 🎯 Objetivo: 3-6 meses de gastos esenciales
Con tus gastos actuales, necesitas un fondo de emergencia de aproximadamente **3.000-6.000€**

### 📈 Por qué un depósito específico para emergencias

**Ventajas del depósito a plazo:**
- Rentabilidad garantizada: 2-3% TAE actual
- Sin riesgo: Capital 100% garantizado
- Disponibilidad: Cancelación sin penalización en muchos casos
- Separación psicológica: No tentación de gastarlo

**Comparativa:**
- Cuenta corriente: 0% rentabilidad = Pierdes dinero con la inflación
- Depósito 3% TAE: +90€/año por cada 3.000€
- En 3 años: +270€ extra para tu fondo

### 🔄 Sistema de construcción automática

**Mes 1-3: Fase de arranque**
- Deposita 200-300€/mes
- Empieza con depósito a 3 meses renovable
- Objetivo: Alcanzar 1.000€ (1 mes de gastos)

**Mes 4-9: Fase de crecimiento**
- Aumenta a 300-400€/mes si es posible
- Cambia a depósito a 6 meses para mejor rentabilidad
- Objetivo: Alcanzar 3.000€ (3 meses de gastos)

**Mes 10-18: Fase de consolidación**
- Mantén aportaciones de 200€/mes
- Objetivo: Alcanzar 6.000€ (6 meses de gastos)

### 💡 Estrategia inteligente de escalera

Divide tu fondo en 3 depósitos:
1. **33% a 1 mes** - Emergencias inmediatas
2. **33% a 3 meses** - Emergencias a corto plazo
3. **34% a 6 meses** - Máxima rentabilidad

Esto te da liquidez + rentabilidad optimizada

### 🚨 Cuándo usar el fondo (y cuándo NO)

**SÍ es emergencia:**
- Pérdida de empleo
- Reparación urgente de coche para trabajar
- Gastos médicos no cubiertos
- Avería de electrodoméstico esencial

**NO es emergencia:**
- Vacaciones
- Ropa nueva
- Actualización de móvil
- Cenas y ocio

### 📊 Tu progreso esperado
- Mes 3: 1.000€ - Primer nivel de seguridad ✓
- Mes 6: 2.000€ - Respiras más tranquilo ✓
- Mes 9: 3.000€ - 3 meses cubiertos ✓
- Mes 12: 4.000€ - Seguridad consolidada ✓
- Mes 18: 6.000€ - Libertad financiera básica ✓

### 🎁 Bonus: Rentabilidad extra
Con las ofertas actuales de bienvenida, puedes conseguir:
- +50-100€ de bonus por contratar el depósito
- Rentabilidad promocional del 4% el primer año
- Regalo adicional por traer tu nómina

### ⚡ Acción inmediata
1. Calcula exactamente cuánto necesitas (3x gastos mensuales)
2. Abre el depósito hoy mismo (proceso 100% online)
3. Programa transferencia automática mensual
4. Olvídate de él hasta que sea una emergencia real",
  active: true
)

# ============================
# PARED VERTICAL - Liberándose de Deudas
# ============================

Recommendation.create!(
  slug: "debt_optimization",
  title: "Reunificación Inteligente de Deudas",
  description: "Reduce tus pagos mensuales hasta un 40% y elimina tus deudas años antes con una estrategia de consolidación",
  content: "## Convierte 5 pagos en 1 y ahorra miles de euros

Estás pagando múltiples deudas con diferentes intereses. Es hora de tomar el control.

### 📊 Tu situación actual (ejemplo típico)
- Tarjeta 1: 2.000€ al 20% = 167€/mes
- Tarjeta 2: 1.500€ al 22% = 125€/mes  
- Préstamo coche: 8.000€ al 9% = 250€/mes
- Microcrédito: 1.000€ al 25% = 100€/mes
- **Total: 642€/mes en 4 pagos diferentes**

### ✅ Situación optimizada con reunificación
- Préstamo único: 12.500€ al 7.5%
- **Pago único: 395€/mes**
- **Ahorro mensual: 247€ (38% menos)**
- **Ahorro total en intereses: 4.200€**

### 🎯 Estrategia de reunificación inteligente

**Paso 1: Análisis (Esta semana)**
- Suma total de deudas actuales
- Calcula el TAE medio ponderado
- Identifica tu capacidad de pago real

**Paso 2: Comparación (Semana 2)**
- Solicita 3 ofertas de diferentes entidades
- Compara TAE, comisiones y flexibilidad
- Negocia usando las ofertas como palanca

**Paso 3: Optimización (Semana 3-4)**
- Elige la mejor oferta (no solo el TAE más bajo)
- Incluye cláusula de amortización anticipada sin penalización
- Mantén el pago anterior si puedes (eliminas deuda más rápido)

### 💰 Técnica secreta: Mantén el pago original

**Si puedes permitírtelo:**
- Sigue pagando los 642€ originales
- Los 247€ extra van a capital
- Resultado: Deuda eliminada en 24 meses vs 48 meses
- Ahorro adicional: 2.800€ en intereses

### ⚠️ Errores mortales a evitar
1. **NO incluyas la hipoteca** - Perderías las ventajas fiscales
2. **NO alargues el plazo innecesariamente** - Pagarías más intereses
3. **NO refinancies sin plan** - Volverías a endeudarte
4. **NO aceptes la primera oferta** - Siempre hay margen de negociación

### 📈 Casos de éxito reales

**Carlos, 35 años:**
*'Pasé de pagar 720€/mes en 5 deudas a 420€ en un solo préstamo. Con los 300€ extra mensuales, he creado mi fondo de emergencia y ahora estoy amortizando anticipadamente.'*

**Laura, 42 años:**
*'La reunificación me salvó. Reduje mis pagos un 35% y en lugar de 6 años de deudas, las liquidaré en 3. He ahorrado más de 5.000€ en intereses.'*

### 🔧 Herramientas incluidas
- Calculadora de reunificación personalizada
- Checklist de documentación necesaria
- Plantilla de negociación con bancos
- Simulador de ahorro por amortización anticipada

### 🚀 Plan de acción inmediato
1. **Hoy:** Recopila todos tus préstamos y calcula el total
2. **Mañana:** Solicita cita/videollamada con tu banco
3. **Esta semana:** Consigue 3 ofertas diferentes
4. **Próxima semana:** Cierra la mejor opción
5. **Próximo mes:** Disfruta de pagar menos y dormir mejor

### 💡 Bonus: Préstamo pre-aprobado
Muchas entidades ofrecen pre-aprobación online en 2 minutos. Esto te da poder de negociación con tu banco actual.",
  active: true
)

# ============================
# CRESTA ESTABLE & ALTA MONTAÑA - Invirtiendo
# ============================

Recommendation.create!(
  slug: "mortgage_optimization",
  title: "Optimización de Hipoteca",
  description: "Ahorra entre 20.000€ y 50.000€ en tu hipoteca con estrategias de reducción de intereses y amortización",
  content: "## Tu hipoteca esconde miles de euros en ahorros potenciales

La mayoría paga 40.000€ de más en su hipoteca. No seas uno de ellos.

### 💸 Dónde estás perdiendo dinero ahora mismo

**Hipoteca típica de 200.000€ a 30 años:**
- Al 3.5%: Pagarás 323.000€ (123.000€ en intereses)
- Al 2.5%: Pagarás 284.000€ (84.000€ en intereses)
- **Diferencia: 39.000€ que podrían ser tuyos**

### 🎯 Estrategia 1: Renegociación o cambio de banco

**Momento perfecto para actuar:**
- Los tipos han bajado desde tu contratación
- Tu hipoteca tiene más de 2 años
- Has mejorado tu perfil crediticio
- Tu vivienda se ha revalorizado

**Proceso de optimización (30 días):**
1. Solicita oferta vinculante de 3 bancos
2. Presenta la mejor a tu banco actual
3. Negocia: tipo, comisiones, productos vinculados
4. Si no mejoran, ejecuta el cambio

**Costes vs Beneficios:**
- Coste cambio: 2.000-4.000€ (tasación, notaría, registro)
- Ahorro medio: 150-300€/mes
- Recuperas inversión: 8-15 meses
- Ahorro total: 20.000-40.000€

### 🚀 Estrategia 2: Sistema de amortización inteligente

**Amortización anticipada optimizada:**
- Amortiza en enero (máximo ahorro en intereses)
- Reduce cuota vs reducir plazo (según tu situación)
- Usa pagas extra, bonus, devolución IRPF

**Ejemplo real:**
- Amortización de 10.000€ en año 5
- Reduces plazo en 3 años
- Ahorras 18.000€ en intereses
- ROI: 180% garantizado sin riesgo

### 📊 Estrategia 3: Cambio de hipoteca variable a fija (o viceversa)

**Variable a Fija (si tienes variable):**
- Protección ante subidas de tipos
- Tranquilidad en pagos mensuales
- Ideal si quedan >15 años

**Fija a Variable (si tienes fija alta):**
- Aprovecha tipos bajos actuales
- Ahorro inmediato mensual
- Ideal si quedan <10 años o planeas amortizar

### 💡 Técnicas avanzadas de ahorro

**1. Método 13 pagos:**
- Divide pago mensual entre 12
- Añade esa cantidad extra cada mes
- Resultado: 1 pago extra al año
- Reduces hipoteca en 7 años

**2. Redondeo inteligente:**
- Pago actual: 847€ → Paga 900€
- 53€ extra/mes = 636€/año a capital
- Ahorro total: 12.000€ en intereses

**3. Bonificaciones máximas:**
- Domicilia nómina: -0.30%
- Contrata seguros: -0.20%
- Tarjetas: -0.10%
- Plan pensiones: -0.10%
- **Total: Hasta -0.70% en tu tipo**

### ⚠️ Errores que cuestan miles de euros
- Ignorar la revisión anual de condiciones
- No reclamar gastos de constitución (media: 2.000€)
- Mantener seguros caros del banco
- No aprovechar deducciones fiscales
- Amortizar cuando hay mejores inversiones

### 📱 Herramientas de optimización
- Simulador de ahorro por cambio de hipoteca
- Calculadora de amortización anticipada
- Comparador de ofertas bancarias
- Checklist de documentación

### 🎁 Oportunidad actual del mercado
- Guerra hipotecaria entre bancos
- Ofertas agresivas para captar clientes
- Bonificaciones de hasta 3.000€ por traslado
- Tipos preferenciales históricos

### ⚡ Plan de acción esta semana
1. **Lunes:** Revisa condiciones actuales de tu hipoteca
2. **Martes:** Simula ahorro potencial online
3. **Miércoles:** Solicita ofertas de 3 bancos
4. **Jueves:** Programa cita con tu banco actual
5. **Viernes:** Toma decisión y activa el cambio",
  active: true
)

Recommendation.create!(
  slug: "portfolio_optimization",
  title: "Cartera de Inversión Diversificada",
  description: "Maximiza rentabilidad y minimiza riesgo con una cartera profesional adaptada a tus objetivos",
  content: "## Deja de perder dinero con la inflación - Haz que tu patrimonio trabaje para ti

Tu dinero en cuenta corriente pierde un 3-4% anual. Es hora de ponerlo a trabajar.

### 📊 Tu situación actual vs potencial

**Situación típica (100.000€ patrimonio):**
- Cuenta corriente (60.000€): 0% = -3% real con inflación
- Depósito plazo (40.000€): 2% = -1% real
- **Pérdida anual real: -2.200€**

**Situación optimizada:**
- Liquidez (10%): 10.000€ al 2%
- Renta fija (30%): 30.000€ al 4%
- Renta variable (40%): 40.000€ al 8%
- Alternativas (20%): 20.000€ al 6%
- **Ganancia anual esperada: +6.000€**
- **Diferencia: +8.200€/año**

### 🎯 Diseño de cartera según tu perfil

**Perfil Conservador (Horizonte 2-5 años):**
- 20% Liquidez/Emergencias
- 50% Renta fija (bonos, depósitos)
- 20% Renta variable (índices)
- 10% REITs/Inmobiliario

**Perfil Moderado (Horizonte 5-10 años):**
- 10% Liquidez
- 30% Renta fija
- 45% Renta variable
- 15% Alternativas (REITs, materias primas)

**Perfil Dinámico (Horizonte >10 años):**
- 5% Liquidez
- 20% Renta fija
- 60% Renta variable
- 15% Alternativas/Cripto

### 🔄 Sistema de construcción gradual

**Mes 1-3: Base sólida**
- Mantén 3-6 meses gastos en liquidez
- Abre cuenta de valores
- Invierte 1.000€/mes en fondo índice global

**Mes 4-6: Diversificación**
- Añade bonos corporativos (rating A o superior)
- Incluye mercados emergentes (10% máximo)
- Considera REITs para exposición inmobiliaria

**Mes 7-12: Optimización**
- Rebalancea trimestralemente
- Añade posiciones tácticas
- Implementa coberturas si es necesario

### 💡 Estrategias profesionales al alcance

**1. Dollar Cost Averaging (DCA):**
- Invierte cantidad fija mensualmente
- Reduces impacto de volatilidad
- Automatiza y olvida
- Rentabilidad histórica: 7-9% anual

**2. Rebalanceo trimestral:**
- Vende lo que ha subido mucho
- Compra lo que ha bajado
- Mantén proporciones objetivo
- Ganancia extra: +1-2% anual

**3. Optimización fiscal:**
- Usa cuentas con ventajas fiscales
- Compensa plusvalías con minusvalías
- Difiere impuestos legalmente
- Ahorro fiscal: 20-30% de ganancias

### 📈 Productos específicos recomendados

**Fondos indexados (Core):**
- MSCI World: Exposición global
- S&P 500: Grandes empresas USA
- STOXX 600: Empresas europeas
- Costes: 0.10-0.30% anual

**ETFs temáticos (Satellite):**
- Tecnología disruptiva
- Energías renovables
- Salud y biotecnología
- Economías emergentes

**Renta fija diversificada:**
- Bonos gubernamentales AAA
- Bonos corporativos grado inversión
- Bonos ligados a inflación
- Depósitos estructurados con capital garantizado

### ⚠️ Errores que destruyen patrimonio
- Intentar hacer timing del mercado
- Concentrar en un solo activo/sector
- Vender en pánico durante caídas
- No tener plan escrito
- Ignorar los costes y comisiones

### 🛡️ Gestión de riesgo profesional

**Diversificación mínima:**
- Nunca >5% en acción individual
- Nunca >20% en sector específico
- Nunca >30% en país individual
- Siempre 10-20% liquidez disponible

**Stop-loss y objetivos:**
- Define pérdida máxima aceptable
- Establece objetivos de beneficio
- Rebalance cuando desvío >10%
- Revisa estrategia anualmente

### 🎓 Formación incluida
- Curso básico de inversión (10 horas)
- Webinars mensuales con expertos
- Informes de mercado semanales
- Asesoramiento inicial personalizado

### 🚀 Tu hoja de ruta personalizada
1. **Semana 1:** Análisis situación actual y objetivos
2. **Semana 2:** Diseño cartera personalizada
3. **Semana 3:** Apertura cuentas y primeras inversiones
4. **Mes 2:** Implementación completa
5. **Trimestral:** Revisión y rebalanceo

### 💰 Proyección a 10 años (100.000€ iniciales)
- Escenario conservador (5% anual): 163.000€
- Escenario moderado (7% anual): 197.000€
- Escenario optimista (9% anual): 237.000€
- **Sin hacer nada (inflación 3%): 74.000€ poder adquisitivo**",
  active: true
)

# ============================
# CIMA CONQUISTADA - Libertad Financiera
# ============================

Recommendation.create!(
  slug: "tax_advisory",
  title: "Optimización Fiscal y Patrimonial",
  description: "Estrategias legales para reducir tu factura fiscal hasta un 30% y proteger tu patrimonio",
  content: "## Paga solo lo justo - Optimiza legalmente tu situación fiscal

Los contribuyentes informados ahorran una media de 5.000-15.000€ anuales en impuestos.

### 💰 Áreas de optimización fiscal inmediata

**IRPF - Ahorro potencial: 2.000-8.000€/año**
- Deducciones no aplicadas (media: 1.200€)
- Aportaciones planes de pensiones (hasta 1.500€)
- Deducción por maternidad/familia numerosa
- Gastos deducibles actividad económica
- Compensación pérdidas patrimoniales

**Patrimonio - Ahorro potencial: 3.000-10.000€/año**
- Reestructuración societaria
- Uso de sociedades patrimoniales
- Optimización de herencias y donaciones
- Planificación sucesoria
- Cambio de residencia fiscal

**Inversiones - Ahorro potencial: 1.000-5.000€/año**
- Compensación plusvalías/minusvalías
- Diferimiento de tributación
- Productos con ventajas fiscales
- Traspasos entre fondos sin tributar
- SICAVs y seguros de ahorro

### 📊 Caso real: Familia con 150.000€ ingresos

**Antes de optimización:**
- IRPF: 45.000€
- Patrimonio: 2.000€
- Total: 47.000€

**Después de optimización:**
- IRPF: 38.000€ (planes pensiones, deducciones)
- Patrimonio: 500€ (reestructuración)
- Total: 38.500€
- **Ahorro anual: 8.500€**

### 🎯 Estrategias avanzadas de planificación

**1. Estructura societaria óptima:**
- Holding familiar para gestión patrimonio
- Reducción 95% en dividendos
- Exención en transmisiones familiares
- Optimización de rendimientos

**2. Planificación sucesoria:**
- Donaciones en vida con reducciones
- Uso del pacto sucesorio
- Seguros de vida como herramienta
- Testamento optimizado fiscalmente

**3. Residencia fiscal estratégica:**
- Análisis de cambio de comunidad
- Posibilidad de residencia en el extranjero
- Convenios de doble imposición
- Planificación de la jubilación

### 🛡️ Protección patrimonial integral

**Blindaje de activos:**
- Separación patrimonio personal/profesional
- Uso de sociedades limitadas
- Seguros de responsabilidad civil
- Constitución de patrimonio protegido

**Herramientas de protección:**
- Trust y fundaciones
- Sociedades patrimoniales
- Seguros unit linked
- Planes de previsión asegurados

### 📈 Inversiones con ventajas fiscales

**Productos estrella:**
- Planes de pensiones: -30% IRPF
- PIAS: Renta vitalicia exenta
- Seguros de ahorro: Diferimiento fiscal
- Fondos de inversión: Traspasos sin tributar
- Plan de Ahorro 5: Exención a 5 años

**Deducciones por inversión:**
- Empresas de nueva creación: -30%
- Vivienda habitual (casos específicos)
- Donativos: hasta -80%
- Patrimonio histórico: -15%

### ⚠️ Errores que cuestan miles
- No planificar operaciones patrimoniales
- Desconocer deducciones autonómicas
- No compensar pérdidas y ganancias
- Tributar de más por desconocimiento
- No actualizar planificación anualmente

### 📋 Servicios incluidos en asesoramiento

**Análisis inicial completo:**
- Revisión 3 últimas declaraciones
- Detección de optimizaciones
- Plan de acción personalizado
- Estimación de ahorro

**Gestión continua:**
- Planificación fiscal anual
- Presentación de declaraciones
- Alertas de oportunidades
- Representación ante Hacienda

**Asesoramiento patrimonial:**
- Estructuración societaria
- Planificación sucesoria
- Optimización de inversiones
- Protección de activos

### 💡 Oportunidades 2024

**Cambios normativos favorables:**
- Nuevas deducciones por eficiencia energética
- Mejoras en tributación de startups
- Beneficios fiscales por teletrabajo
- Deducciones por familia

**Planificación fin de año:**
- Venta de activos con minusvalías
- Aportaciones máximas a pensiones
- Donativos deducibles
- Regularización de situaciones

### 🚀 Plan de implementación

**Mes 1: Diagnóstico**
- Análisis situación actual
- Identificación de oportunidades
- Cuantificación del ahorro potencial

**Mes 2: Estrategia**
- Diseño plan optimización
- Calendario de actuaciones
- Documentación necesaria

**Mes 3-12: Ejecución**
- Implementación de medidas
- Seguimiento mensual
- Ajustes según cambios normativos

### 📊 ROI del asesoramiento
- Coste servicio: 1.500-3.000€/año
- Ahorro medio: 5.000-15.000€/año
- **Retorno: 300-500% primer año**
- Ahorro acumulado 5 años: 25.000-75.000€",
  active: true
)

# ============================
# OBJETIVOS DE INVERSIÓN
# ============================

Recommendation.create!(
  slug: "ac_diposit",
  title: "Depósito a Corto Plazo",
  description: "Ideal para objetivos de 0-2 años con capital garantizado y disponibilidad",
  content: "## El producto perfecto para tus objetivos a corto plazo

Necesitas seguridad y disponibilidad. Este depósito está diseñado exactamente para eso.

### 🎯 Perfecto para objetivos como:
- Entrada de un coche (6-12 meses)
- Vacaciones del próximo año
- Fondo para reformas
- Colchón para oportunidades
- Regalo importante

### 📈 Características del producto

**Rentabilidad actual:**
- 1.5-2.5% TAE garantizado
- Sin sorpresas ni volatilidad
- Intereses mensuales o al vencimiento

**Flexibilidad total:**
- Plazos desde 3 meses
- Cancelación anticipada sin penalización
- Renovación automática opcional
- Aportaciones adicionales permitidas

**Seguridad máxima:**
- Capital 100% garantizado
- Fondo Garantía Depósitos hasta 100.000€
- Sin riesgo de mercado
- Entidad solvente y regulada

### 💰 Simulación para tu objetivo

Para tu objetivo necesitas ahorrar mensualmente. Con este depósito:
- Aportación mensual calculada
- Intereses generados incluidos
- Disponibilidad cuando lo necesites
- Sin sorpresas desagradables

### ⚡ Ventajas exclusivas
- Bonificación de bienvenida
- Tipo preferente por objetivo
- Sin comisiones
- Gestión 100% online

### 🚀 Contratación en 5 minutos
1. Solicitud online
2. Verificación instantánea
3. Primera aportación
4. Confirmación inmediata",
  active: true
)

Recommendation.create!(
  slug: "ac_curt",
  title: "Fondo Conservador Plazo Medio",
  description: "Equilibrio perfecto entre seguridad y rentabilidad para objetivos de 2-5 años",
  content: "## Haz crecer tu dinero con tranquilidad

Para objetivos a medio plazo, necesitas algo más que un depósito pero sin grandes riesgos.

### 🎯 Diseñado para objetivos como:
- Entrada de vivienda (3-5 años)
- Educación de los hijos
- Cambio de coche premium
- Proyecto personal importante
- Viaje sabático

### 📊 Composición optimizada

**Cartera equilibrada:**
- 70% Renta fija de calidad (bonos AAA)
- 20% Renta variable defensiva
- 10% Liquidez y monetarios

**Rentabilidad objetivo:**
- 3-4% anual medio
- Volatilidad controlada <5%
- Protección en caídas de mercado
- Participación en subidas moderadas

### 💡 Ventajas sobre alternativas

**Vs Depósito tradicional:**
- +1-2% rentabilidad adicional
- Diversificación profesional
- Potencial de crecimiento
- Liquidez diaria

**Vs Fondos agresivos:**
- Menor volatilidad
- Protección del capital
- Consistencia en resultados
- Paz mental

### 📈 Histórico de comportamiento

**Últimos 5 años:**
- Rentabilidad media: 3.2% anual
- Peor año: -1.5%
- Mejor año: +6.8%
- Meses positivos: 82%

### 🛡️ Gestión del riesgo

- Stop-loss automático en -5%
- Rebalanceo mensual
- Cobertura de divisa
- Gestores profesionales con 20+ años experiencia

### 💰 Simulación personalizada

Con tu objetivo y plazo:
- Aportación mensual optimizada
- Escenarios conservador/esperado/optimista
- Probabilidad de éxito: 94%
- Capital final estimado

### 🎁 Condiciones especiales
- Sin comisión de suscripción
- Gestión reducida al 0.75%
- Traspasos gratuitos
- Asesoramiento incluido",
  active: true
)

Recommendation.create!(
  slug: "ac_llarg",
  title: "Cartera Crecimiento Largo Plazo",
  description: "Maximiza el potencial de tus inversiones para objetivos a más de 5 años",
  content: "## Tu futuro merece una estrategia de inversión profesional

Para objetivos a largo plazo, el tiempo es tu mejor aliado. Aprovéchalo.

### 🎯 Objetivos que transformarás en realidad:
- Independencia financiera
- Jubilación anticipada
- Educación universitaria hijos
- Segunda residencia
- Libertad para elegir

### 🚀 Estrategia de máximo crecimiento

**Cartera dinámica global:**
- 60% Renta variable internacional
- 20% Mercados emergentes y small caps
- 15% Inversiones alternativas (REITs, commodities)
- 5% Liquidez táctica

**Potencial de rentabilidad:**
- Objetivo: 7-10% anual medio
- Horizonte: 5-30 años
- Poder del interés compuesto
- Reinversión automática de dividendos

### 📊 El poder del tiempo en números

**Inversión de 500€/mes durante:**
- 5 años: 36.000€ → 42.000€ esperado
- 10 años: 72.000€ → 103.000€ esperado
- 20 años: 144.000€ → 294.000€ esperado
- 30 años: 216.000€ → 591.000€ esperado

### 💎 Estrategias exclusivas incluidas

**1. Dollar Cost Averaging mejorado:**
- Inversión mensual automática
- Compras adicionales en caídas >10%
- Aprovechar la volatilidad a tu favor

**2. Rebalanceo dinámico:**
- Ajuste trimestral de pesos
- Toma de beneficios automática
- Reinversión en activos infravalorados

**3. Diversificación inteligente:**
- 8.000+ empresas en cartera
- 40+ países representados
- Todos los sectores económicos
- Múltiples clases de activos

### 📈 Track record demostrado

**Rentabilidades históricas (datos reales):**
- Últimos 10 años: +8.7% anual
- Últimos 20 años: +7.2% anual
- Desde 1990: +9.1% anual
- Crisis superadas: 5 (todas recuperadas)

### 🛡️ Protección y garantías

- Gestora regulada por CNMV
- Activos en depositario independiente
- Seguro de responsabilidad civil
- Auditoría externa anual
- Transparencia total en operaciones

### 💡 Servicios premium incluidos

**Asesoramiento continuo:**
- Revisión trimestral de cartera
- Llamada anual de estrategia
- Informes mensuales detallados
- Webinars formativos
- App con seguimiento real-time

**Optimización fiscal:**
- Traspasos entre fondos sin tributar
- Compensación de plusvalías/minusvalías
- Asesoramiento en declaración
- Estrategias de diferimiento

### 🎯 Tu plan personalizado

**Simulación para tu objetivo:**
- Capital objetivo alcanzable
- Probabilidad de éxito: 89%
- Aportación mensual óptima
- Hitos intermedios de seguimiento

### 🎁 Oferta de lanzamiento
- 3 meses sin comisiones
- Bonificación 100€ primera aportación
- Curso de inversión valorado en 299€
- Acceso a club inversores premium",
  active: true
)

Recommendation.create!(
  slug: "ac_jubil",
  title: "Plan de Pensiones Crecimiento",
  description: "Construye tu jubilación dorada con ventajas fiscales y máxima rentabilidad",
  content: "## Tu jubilación: El objetivo más importante de tu vida

No es solo un plan de pensiones. Es tu libertad futura con ventajas fiscales HOY.

### 💰 Doble beneficio: Ahorra impuestos HOY y asegura tu FUTURO

**Ahorro fiscal inmediato:**
- Reduce tu base imponible hasta 1.500€/año
- Ahorro en IRPF: 30-47% de lo aportado
- Ejemplo: Aportas 1.500€ → Recuperas 450-705€
- ROI inmediato garantizado por Hacienda

**Crecimiento a largo plazo:**
- Rentabilidad objetivo: 6-8% anual
- Gestión profesional activa
- Sin tributación hasta rescate
- Poder del interés compuesto maximizado

### 📊 La matemática de tu jubilación

**Aportando 150€/mes con desgravación:**
- Aportación real (tras desgravación): 90€/mes
- A los 20 años: 73.000€ acumulados
- A los 30 años: 149.000€ acumulados
- A los 35 años: 214.000€ acumulados

**Vs. No hacer nada:**
- Pensión pública media: 1.200€/mes
- Con plan privado: +800€/mes extra
- Total jubilación: 2.000€/mes
- Mantén tu nivel de vida

### 🎯 Estrategia adaptada a tu edad

**Si tienes 25-35 años:**
- 80% renta variable global
- 20% renta fija y alternativas
- Máximo crecimiento
- Tiempo para recuperar volatilidad

**Si tienes 35-45 años:**
- 60% renta variable
- 30% renta fija
- 10% inversiones alternativas
- Equilibrio crecimiento/seguridad

**Si tienes 45-55 años:**
- 40% renta variable
- 50% renta fija
- 10% liquidez
- Protección de capital con crecimiento

**Si tienes 55+ años:**
- 25% renta variable defensiva
- 65% renta fija calidad
- 10% liquidez
- Preservación y rentas

### 💎 Ventajas exclusivas del plan

**Flexibilidad total:**
- Aportaciones desde 30€/mes
- Modificables en cualquier momento
- Aportaciones extraordinarias permitidas
- Traspasos desde otros planes sin coste

**Opciones de cobro en jubilación:**
- Capital único
- Renta mensual vitalicia
- Mixto capital + renta
- Cobro flexible según necesidades

### 📈 Rendimiento superior demostrado

**Comparativa mercado:**
- Media planes bancarios: 1.2% anual
- Media gestoras independientes: 3.5% anual
- Nuestro plan: 6.8% anual (media 10 años)
- Top 5% mejores planes de España

### 🛡️ Garantías y seguridad

- Depositario independiente
- Regulado por DGSFP
- Auditoría externa anual
- Comité de inversiones experto
- 25 años de experiencia

### 🎁 Calculadora de jubilación personalizada

**Tu situación específica:**
- Edad actual y de jubilación deseada
- Pensión pública estimada
- Capital necesario para mantener nivel de vida
- Aportación mensual recomendada
- Escenarios optimista/realista/conservador

### 💡 Servicios adicionales incluidos

**Planificación integral:**
- Estudio de pensión pública
- Optimización fiscal anual
- Estrategia de rescate óptima
- Coordinación con otros ahorros
- Revisión anual presencial/online

**Formación continua:**
- Seminarios de educación financiera
- Newsletter mensual de mercados
- Acceso a plataforma educativa
- Consultas ilimitadas con expertos

### 🚀 Bonificaciones por traspaso

**Si traes tu plan actual:**
- Bonificación 3% del importe traspasado
- Sin comisiones primer año
- Estudio comparativo gratuito
- Gestión del traspaso incluida
- Regalo de bienvenida

### ⚡ Empieza HOY - El tiempo es dinero

Cada mes que retrasas tu plan de pensiones:
- Pierdes desgravación fiscal
- Reduces tu capital final en miles de euros
- Te alejas de tu jubilación soñada

**Contratación inmediata online:**
1. Alta en 5 minutos
2. Primera aportación hoy mismo
3. Desgravación en próxima declaración
4. Tu futuro asegurado",
  active: true
)

puts "✅ Successfully created #{Recommendation.count} recommendations"

# Create default influencer for testing
puts "🌱 Creating default influencer..."

Influencer.create!(
  name: "Influencer Demo",
  ac_compte: "https://ejemplo-banco.com/cuenta-ahorro",
  ac_cdiposit: "https://ejemplo-banco.com/deposito",
  ac_curt: "https://ejemplo-banco.com/fondo-conservador",
  ac_llarg: "https://ejemplo-banco.com/fondo-crecimiento",
  ac_deute: "https://ejemplo-banco.com/prestamo-reunificacion",
  ac_jubil: "https://ejemplo-banco.com/plan-pensiones",
  ac_fiscal: "https://ejemplo-banco.com/asesoria-fiscal"
)

puts "✅ Successfully created default influencer"

puts "🎉 Seeding completed successfully!"
puts "📊 Total recommendations: #{Recommendation.count}"
puts "👥 Total influencers: #{Influencer.count}"