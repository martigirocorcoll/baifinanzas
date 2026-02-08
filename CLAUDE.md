# BaiFinanzas - Guia de Desarrollo

## Descripcion del Proyecto
App financiera movil (Turbo Native) con sistema de referidos de influencers. Ayuda a usuarios a mejorar su salud financiera con recomendaciones personalizadas, plan de accion y calculadoras interactivas.

## Objetivos de Negocio
1. Ayudar a usuarios a mejorar su situacion financiera - "Que puedo hacer en MI situacion?"
2. Engagement - Que completen toda su informacion financiera
3. Recurrencia - Vuelvan a actualizar datos y recibir nuevas recomendaciones
4. Monetizacion con afiliados - Convertir recomendaciones en clicks y registros

## Documento de Referencia Principal
El plan completo de diseno y arquitectura esta en **`plan.md`** - incluye:
- Decisiones de diseno confirmadas (teal #165668, Inter, light mode)
- Wireframes de todas las pantallas
- 7 calculadoras con especificaciones detalladas
- User journeys completos
- Mapa de pantallas
- Fases de implementacion

---

## Estado de Desarrollo (Actualizado 5 Feb 2026)

### COMPLETADO

#### Sistema de Diseno
- [x] Paleta teal (#165668) con variantes en `_colors.scss`
- [x] Tipografia Inter en `_fonts.scss`
- [x] Variables Bootstrap personalizadas en `_bootstrap_variables.scss`
- [x] Estilos de componentes app en `_app.scss`
- [x] Light mode limpio estilo N26/Fintonic

#### Layout y Navegacion
- [x] Layout `app.html.erb` (PWA-ready, safe areas, meta tags)
- [x] Bottom nav 4 tabs: Home, Discovery, Calculadoras, Perfil (`_bottom_nav.html.erb`)
- [x] App header sticky (`_app_header.html.erb`)
- [x] Rutas con locale scope (ES/EN)

#### Motor Financiero
- [x] Sistema de 6 niveles de salud financiera
- [x] Motor de recomendaciones por nivel
- [x] Calculadora de interes compuesto para objetivos
- [x] Sistema de enlaces de afiliado (`User.get_affiliate_link`)
- [x] Plan de accion unificado (recomendaciones + objetivos)

#### Onboarding (4 campos rapido)
- [x] Welcome page (`onboarding/welcome.html.erb`)
- [x] Formulario basico: ingresos, gastos, ahorros, deudas (`onboarding/basic.html.erb`)
- [x] Guarda datos reales en BD (distribuye en categorias PyG + Balance)
- [x] Pantalla de completado con nivel financiero (`onboarding/complete.html.erb`)
- [x] Redireccion automatica para usuarios nuevos

#### Home / Dashboard (`/home`)
- [x] Seccion 1: Nivel financiero (badge, barra progreso, metricas)
- [x] Seccion 2: Plan de accion (tareas con checkbox, links a recomendaciones)
- [x] Seccion 3: Objetivos (CRUD completo, capacidad de ahorro, alertas)
- [x] Modales para crear/editar objetivos
- [x] Guia de niveles (modal)

#### Paginas de Recomendaciones (`/recommendations/:slug`)
- [x] Vista unificada show.html.erb (maneja 10+ tipos con logica condicional)
- [x] Heroes, CTAs de afiliado, videos de influencer, FAQs
- [x] Graficos de proyeccion para inversiones a largo plazo
- [x] Contenido educativo por recomendacion
- [x] i18n completo (ES/EN)

#### Panel Influencer (Web)
- [x] Login Devise (`/influencers/sign_in`)
- [x] Dashboard con estadisticas y codigo de referido
- [x] Editar enlaces afiliados (10 productos)
- [x] Editar URLs de videos (10 productos)
- [x] Seguridad: solo editar perfil propio

#### Panel Admin (Web)
- [x] Admin via User.admin? (boolean en modelo User)
- [x] CRUD de influencers (crear, editar, eliminar)
- [x] Toggle influencer por defecto
- [x] Vista de estadisticas basicas por influencer

#### Calculadoras Implementadas (4 de 7)
- [x] **Interes Compuesto** - Form + calculo real-time + Chart.js
- [x] **Hipoteca (tab FIJO)** - Cuota mensual, intereses totales
- [x] **Fondo de Emergencia** - Pre-fill con datos usuario, progress bar
- [x] **Libertad Financiera** - Calculo con impuestos 23%, patrimonio necesario

#### Perfil (`/profile`)
- [x] Vista principal con opciones
- [x] Editar datos personales
- [x] Settings (idioma ES/EN)
- [x] Links a editar PyG y Balance

---

### PENDIENTE - Plan de Accion (Deadline: 15 Feb 2026)

#### SPRINT A: Calculadoras Faltantes (Prioridad ALTA)

**A1. Hipoteca - Tabs MIXTO y VARIABLE**
```
Archivo: app/views/calculators/mortgage.html.erb
Estado: Tab FIJO funciona. MIXTO y VARIABLE muestran "coming soon"
Hacer:
- Tab MIXTO: anos fijo inicial, tipo fijo, diferencial, slider Euribor
- Tab VARIABLE: diferencial + slider Euribor, simulacion "si sube"
- Grafico de capital pendiente (Chart.js)
- Impacto del Euribor segun ano de hipoteca
Referencia: plan.md lineas 341-492 (wireframes detallados)
```

**A2. Calculadora de Objetivo de Inversion (NUEVA)**
```
Archivo: app/views/calculators/investment_goal.html.erb
Estado: Solo placeholder "coming soon"
Hacer:
- Input: objetivo capital final, capital inicial, rentabilidad esperada
- 2 modos: calcular aportacion mensual O calcular anos necesarios
- Radio buttons para elegir modo
- Calculo con interes compuesto
Referencia: plan.md lineas 619-684
```

**A3. Calculadora de Amortizacion Anticipada (NUEVA)**
```
Archivo: app/views/calculators/early_repayment.html.erb
Estado: Solo placeholder "coming soon"
Hacer:
- Input: capital pendiente, anos restantes, tipo interes, cantidad anual
- Escenario A: Amortizar cada ano (anos ahorrados, intereses ahorrados)
- Escenario B: Invertir y amortizar de golpe (valor inversion)
- Slider rentabilidad (default 8%)
- Recomendacion automatica segun diferencia tipo hipoteca vs rentabilidad
Referencia: plan.md lineas 688-764
```

**A4. Calculadora de Rentabilidad de Inversion (NUEVA)**
```
Archivo: app/views/calculators/investment_returns.html.erb
Estado: Solo placeholder "coming soon"
Hacer:
- Input: capital invertido, aportaciones adicionales, valor final, anos
- Output: rentabilidad total (euros y %), ROI anualizado, ROE anualizado
- Comparativa visual con benchmarks (inflacion 3%, S&P 500 10%, deposito 2.5%)
- Barras de comparacion
Referencia: plan.md lineas 768-831
```

#### SPRINT B: Discovery Backend (Prioridad MEDIA)

**B1. Mejorar contenido Discovery**
```
Estado actual:
- Vista completa (feed, filtros, cards de video/articulo/novedad)
- Videos: se cargan desde campos URL del modelo Influencer (funciona si hay URLs)
- Articulos: 3 hardcodeados en el controlador
- Novedades: 1 hardcodeada en el controlador
- NO existen modelos Article ni AppNews (no hay migraciones ni tablas)

Opciones:
1. Crear modelos Article + AppNews + migraciones (solucion completa)
2. Mejorar los placeholders con mas contenido hardcodeado (rapido para beta)

Recomendacion: Opcion 2 para beta, Opcion 1 post-launch
```

#### SPRINT C: Landing Page (Prioridad MEDIA)

**C1. Redisenar landing como pagina de descarga**
```
Archivo: app/views/pages/home.html.erb
Estado: Sigue siendo la landing antigua (hero, features, FAQ, testimonials)
Hacer:
- Redisenar como pagina de descarga de app
- Badges App Store / Play Store (placeholder)
- Screenshots de la app
- CTA claro hacia descarga
Referencia: plan.md lineas 2194-2205
```

#### SPRINT D: Polish y Turbo Native (Prioridad BAJA)

**D1. Preparacion Turbo Native**
```
- turbo_native_app? helper
- Meta tags para app
- Assets para stores (iconos, splash screens)
```

**D2. Testing responsive**
```
- Verificar todas las vistas en iPhone SE, iPhone 12, iPad
- Verificar calculadoras con diferentes valores
- Flujo completo: registro -> onboarding -> dashboard -> calculadoras -> perfil
```

---

## Arquitectura Tecnica

### Modelos
| Modelo | Tabla | Descripcion |
|--------|-------|-------------|
| `User` | users | Devise auth, belongs_to influencer, campo admin (boolean) |
| `Influencer` | influencers | Devise auth, has_many users, 10 campos afiliado + 10 campos video |
| `Pyg` | pygs | Profit & Loss, belongs_to user |
| `Balance` | balances | Activos y pasivos, belongs_to user |
| `Objective` | objectives | Metas financieras, belongs_to user |
| `Recommendation` | recommendations | Contenido estatico con slug |
| `UserAction` | user_actions | Tracking de acciones completadas |

### Metodos Clave del User
```ruby
# Salud financiera
financial_health_level_key    # :critical, :emergency_fund, :paying_debt, :stable, :growth, :financial_freedom
financial_health_level_number # 1-6
monthly_cash_flow
net_worth

# Plan de accion
action_plan                   # Array unificado de recomendaciones + objetivos
current_task                  # Primera accion no completada
complete_recommendation!(key)
uncomplete_recommendation!(key)

# Afiliados
get_affiliate_link(product_type) # URL del influencer asignado o nil
```

### Metodos Clave del Objective
```ruby
investment_recommendation  # ac_diposit (<2a), ac_curt (2-5a), ac_llarg (>5a), ac_jubil (jubilacion)
annual_return_rate         # 0.015, 0.03, 0.08
monthly_savings_needed     # Calculo con interes compuesto
objective_icon             # Icono Bootstrap segun keywords del titulo
savings_capacity_analysis  # { sufficient, monthly_needed, available_cash_flow }
```

### Calculadoras - Formulas
```
Interes compuesto: FV = P(1+r)^n + PMT * (((1+r)^n - 1) / r)
Cuota hipoteca:    M = P * [r(1+r)^n] / [(1+r)^n - 1]
Libertad financiera: patrimonio = (gastos_anuales / 0.77) / rentabilidad
Fondo emergencia:  objetivo = gastos_mensuales * meses_colchon
```

### Navegacion App (4 tabs)
```
Tab 1 - Home:         /home           (HomeController)
Tab 2 - Discovery:    /discovery      (DiscoveryController)
Tab 3 - Calculadoras: /calculators    (CalculatorsController)
Tab 4 - Perfil:       /profile        (ProfilesController)
```

### Rutas Calculadoras
```
/calculators                    -> index (lista 7 calculadoras)
/calculators/compound_interest  -> Interes Compuesto
/calculators/mortgage           -> Cuota Hipotecaria (3 tabs)
/calculators/emergency_fund     -> Fondo de Emergencia
/calculators/financial_freedom  -> Libertad Financiera
/calculators/investment_goal    -> Objetivo de Inversion
/calculators/early_repayment    -> Amortizacion Anticipada
/calculators/investment_returns -> Rentabilidad de Inversion
```

### Sistema de Diseno
```
Color marca:       #165668 (Teal profundo)
Color marca light: #1d7a8c
Texto principal:   #1a1a1a
Texto secundario:  #6b7280
Fondo principal:   #ffffff
Fondo secundario:  #f9fafb
Exito:             #10b981
Warning:           #f59e0b
Danger:            #ef4444
Tipografia:        Inter (300-700)
Border radius:     8-12px
Animaciones:       Sutiles (200ms fades/slides)
```

### Contextos de Layout
```
App (usuarios):     layout "app"     -> bottom nav, sin navbar superior
Landing (web):      layout "landing" -> navbar visitante, footer
Admin/Influencer:   layout "admin"   -> navbar web completa
```

---

## Resumen Ejecutivo

**Estado:** ~85% completado. Core funcional, diseno profesional implementado.

**Para Beta (15 Feb):**
- 3 calculadoras nuevas + 2 tabs hipoteca (Sprint A)
- Mejorar contenido Discovery (Sprint B)
- Opcional: landing de descarga (Sprint C)

**Post-Beta:**
- Modelos Article/AppNews con migraciones
- Panel admin ampliado (gestionar articulos/novedades)
- Email automation
- Turbo Native compilacion iOS/Android

---

## PENDIENTE: Cambio de dominio

Cuando se tenga un dominio definitivo (ej. `baifinanzas.com`) hay que actualizar:
1. `ios/BaiFinanzas/BaiFinanzas/Configuration/Server.swift` - cambiar `baseURL`
2. `public/.well-known/apple-app-site-association` - ya esta servido, pero verificar accesibilidad en nuevo dominio
3. Xcode > Signing & Capabilities > Associated Domains - cambiar `webcredentials:DOMINIO`
4. Apple Developer > Identifiers > configurar el Associated Domain con el nuevo dominio
5. Heroku/hosting: asegurar que `/.well-known/apple-app-site-association` se sirve con `Content-Type: application/json`
