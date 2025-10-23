# BaiFinanzas Development Progress

## Project Overview
Financial platform with influencer referral system focused on helping users achieve financial health through personalized recommendations and investment guidance.

## 🎯 Business Objectives
1. **Help users improve their financial situation** - Answer "what can I do in my specific situation?"
2. **Drive engagement** - Get users to complete all their financial information
3. **Increase recurrence** - Users return to update status and receive new recommendations
4. **Monetize with affiliates** - Convert recommendations into affiliate clicks and signups

---

## Development Phases

### ✅ PHASE 1: Core Foundation (Week 1-2) - COMPLETED
1. ✅ Complete mobile-first responsive design - Fix all forms and dashboard for mobile
2. ✅ Finish landing page components - Complete hero, features, testimonials, FAQ, CTA sections
3. ✅ Add referral tracking - Implement signup with influencer referral codes
4. ✅ Basic form validation - Ensure all financial forms work properly

### ✅ PHASE 2: Financial Engine (Week 3-4) - COMPLETED
5. ✅ **Financial scoring system** - 6-level health system implemented:
   - "Valle Profundo" → Negative/minimal cash flow
   - "Campo Base" → Building emergency fund (positive cash flow)
   - "Pared Vertical" → Paying off expensive debt + partial emergency fund
   - "Cresta Estable" → Has emergency fund, no expensive debt, positive cash flow
   - "Alta Montaña" → Net worth ≥ 2x annual income
   - "Cima Conquistada" → Investment income ≥ monthly expenses

6. ✅ **Recommendation engine** - Product suggestions based on financial health level:
   - Basic recommendations per level (bank accounts, debt optimization, etc.)
   - Objective-specific investment recommendations
   - Integration with influencer affiliate links

7. ✅ **Compound interest calculator** - Objective-specific calculations:
   - Short-term (0-2 years): 1.5% return → `ac_diposit`
   - Medium-term (2-5 years): 3% return → `ac_curt`
   - Long-term (5+ years): 8% return → `ac_llarg`
   - Retirement objectives: 8% return → `ac_jubil`
   - Savings capacity analysis with deficit detection

8. ✅ **Affiliate link integration** - Connect recommendations to influencer URLs:
   - Influencer model has fields: ac_compte, ac_cdiposit, ac_curt, ac_llarg, ac_deute, ac_jubil
   - User.recommendations_with_links() returns products with affiliate URLs
   - Automatic mapping based on recommendation type

### ✅ PHASE 3: Dashboard & Recommendations (Week 5-6) - COMPLETED
9. ✅ **Complete dashboard system** - 3-state dashboard based on user financial data
   - State 1: New user (PyG form embedded)
   - State 2: Has PyG data (Balance form + PyG analysis)
   - State 3: Complete dashboard (Financial health + recommendations + objectives)

10. ✅ **Financial mountain progress** - Visual journey through financial health levels
    - Valle Profundo → Campo Base → Pared Vertical → Cresta Estable → Alta Montaña → Cima Conquistada
    - Progress indicators with Bootstrap icons and completion status

11. ✅ **Recommendation system** - Personalized recommendations based on financial health
    - Base recommendations per financial level
    - Objective-specific investment recommendations
    - Duplicate filtering (base vs objective recommendations)
    - Human-friendly titles and descriptions in dashboard

12. ✅ **Objectives management** - Complete objective creation and tracking
    - Create objectives with target amount and date
    - Monthly savings calculations with compound interest
    - Investment recommendation per objective (ac_diposit, ac_curt, ac_llarg, ac_jubil)
    - Delete objectives from dashboard
    - Savings capacity analysis

13. ✅ **Recommendation pages system** - Detailed recommendation pages
    - Recommendation model with slug, title, description, content
    - RecommendationsController with show action
    - Routes system for /recommendations/:slug and /recommendations/:slug?objetivo_id=X
    - Investment evolution charts with Chart.js
    - Multiple CTA placements for conversion
    - Clean, simplified design optimized for mobile

---

## 🚀 PHASE 4: Complete Redesign & Launch Preparation (CURRENT - Oct 20 - Nov 14, 2024)

### **Context: Product-Market Fit Analysis**
After analyzing current implementation, we identified a complete redesign needed to:
- Increase user engagement and action-taking through better UX
- Improve conversion to affiliate products with clear value proposition
- Implement influencer referral system for organic growth
- Differentiate dashboard experience for LOW vs HIGH financial levels
- Add email automation for user retention

### **Design Principles**
1. **Action over analysis** - Prioritize what to do vs understanding numbers
2. **NO false promises** - Never show specific guaranteed € amounts (generic benefits only)
3. **Preventive validation** - Warn before creating unaffordable objectives
4. **Visible progress** - Bars, checkboxes, status badges
5. **Dense info in show pages** - Keep dashboard clean, details in specific pages
6. **Mobile-first** - Prioritize elements for small screens

---

### 📋 **A. HOMEPAGE REDESIGN**

#### **Headline (approved):**
```
Tu plan financiero personalizado
100% gratis
```

#### **Subtitle (opción 4 - approved):**
```
Descubre en qué nivel financiero estás y recibe recomendaciones
personalizadas para mejorar tu situación. Totalmente gratis y sin
compromisos.
```

#### **Sections:**
1. **Hero** - Headline + Subtitle + CTA "Comenzar gratis"
2. **¿Cómo funciona?** - 3 pasos: Completa perfil → Recibe análisis → Actúa
3. **Niveles financieros** - Breve descripción de los 6 niveles
4. **Beneficios** - Personalización, gratis, privado, accionable
5. **FAQ** - 5-6 preguntas frecuentes
6. **CTA final** - "Comienza tu plan ahora"

#### **Technical notes:**
- UTM tracking on all CTAs (for influencer attribution)
- Mobile-first responsive design
- Fast loading (optimize images, minimal JS)

---

### 📋 **B. ONBOARDING FLOW**

**5 Steps after signup:**

```
1. Signup (email + password)
   ↓
2. Welcome page
   "¡Bienvenido! Vamos a crear tu plan financiero en 2 pasos."
   Progress: 0%
   ↓
3. PyG Form (embedded in welcome page)
   Título: "Paso 1: Tus ingresos y gastos mensuales"
   Progress: 50%
   ↓
4. Balance Form
   Título: "Paso 2: Tu situación patrimonial"
   Progress: 100%
   ↓
5. Loading screen (5 seconds)
   "Analizando tu situación financiera..."
   Animated spinner
   ↓
6. Dashboard complete
   Show financial health level + recommendations
```

#### **Technical implementation:**
- Welcome page route: `/welcome` (only accessible after signup, before PyG completed)
- Redirect logic:
  - After signup → `/welcome`
  - After PyG completed → `/balance/edit`
  - After Balance completed → `/loading`
  - After loading → `/dashboard`
- Loading screen: Simple HTML page with CSS animation (5 second timer with JS)
- No risk_profile during signup (removed to reduce friction)

---

### 📋 **C. INFLUENCER SYSTEM**

#### **Goal:**
Influencers get unique referral code and track signups via UTM parameters.

#### **Technical specs:**

**1. Influencer Model changes:**
```ruby
# Add Devise authentication
devise :database_authenticatable, :rememberable

# 8 video fields (string - URLs to YouTube/Vimeo)
- video_compte (cuenta bancaria)
- video_cdiposit (depósito emergencia)
- video_curt (inversión corto plazo)
- video_llarg (inversión largo plazo)
- video_deute (optimización deudas/hipoteca)
- video_jubil (plan jubilación)
- video_fiscal (asesoría fiscal)
- video_portfolio (optimización cartera)

# Auto-generate unique code
after_create :generate_unique_code

def generate_unique_code
  self.code = "#{name.parameterize}-#{SecureRandom.hex(4)}"
  save
end
```

**2. Routes:**
```ruby
# Influencer authentication
devise_for :influencers, path: 'influencers', controllers: {
  sessions: 'influencers/sessions'
}

# Influencer dashboard
namespace :influencers do
  get 'dashboard', to: 'dashboard#show'
end
```

**3. Influencer Dashboard (simple):**
- Show unique code
- Show referral link: `https://baifinanzas.com/?utm_source=influencer&utm_campaign=#{code}`
- Button "Copiar enlace"
- (Optional future: show clicks, signups if easy to implement)

**4. UTM Tracking:**
```ruby
# ApplicationController
before_action :track_utm

def track_utm
  if params[:utm_source] == 'influencer' && params[:utm_campaign].present?
    cookies[:influencer_code] = { value: params[:utm_campaign], expires: 30.days }
    session[:influencer_code] = params[:utm_campaign]
  end
end

# User model - after_create callback
def assign_influencer_from_utm
  if session[:influencer_code].present?
    influencer = Influencer.find_by(code: session[:influencer_code])
    update(influencer: influencer) if influencer
  end
end
```

**5. Displaying videos in recommendation pages:**
```erb
<% if current_user.influencer&.video_#{type}.present? %>
  <div class="influencer-video">
    <h3>Recomendación en video</h3>
    <iframe src="<%= current_user.influencer.video_#{type} %>"></iframe>
  </div>
<% end %>
```

---

### 📋 **D. DASHBOARD DIFFERENTIATION (LOW vs HIGH)**

#### **Visual Hierarchy:**

**LOW LEVEL (Valle Profundo, Campo Base, Pared Vertical):**
```
1. Header (nivel actual + "Última actualización hace X días")
2. Card "Próximo nivel" (what's missing to level up)
3. 📋 BASE Recommendations (MAIN FOCUS - 80% attention)
   - Ordered by priority (see section E)
   - Show first action prominently (Proposition A)
   - Generic benefits per recommendation (Proposition B)
   - Social proof: "X% de usuarios en tu nivel ya hicieron esto"
4. 🔒 "Desbloquea Objetivos"
   - "Alcanza Cresta Estable para planificar tu futuro financiero"
5. 📊 PyG + Balance Analysis (collapsible accordion)
```

**HIGH LEVEL (Cresta Estable, Alta Montaña, Cima Conquistada):**
```
1. Header (nivel actual + "Última actualización hace X días")
2. 🎉 "¡DESBLOQUEADO! Planifica tu futuro" (solo primera vez alcanzando Cresta)
3. 💰 Savings Capacity Widget (3 estados: healthy/high/exceeded)
4. 🎯 Personalized OBJECTIVES (MAIN FOCUS - 80% attention)
   - Objective cards (3 estados: new/on-track/off-track)
   - Button "+ Crear nuevo objetivo"
   - Deficit alert if capacity exceeded
5. 📋 BASE Recommendations (collapsible, less prominent)
   - Still ordered by priority
6. 📊 PyG + Balance Analysis (collapsible accordion)
```

#### **Common Elements:**
- "Actualizar datos" button
- Badge "Última actualización hace X días"
- "Next Level" card (what requirements are missing)

#### **Elements to REMOVE:**
- ❌ Full mountain progress visualization (too much space)
- ❌ Animated arrows between sections
- ❌ Inline objective creation form (use modal instead)

---

### 📋 **E. ACTION ORDERING BY FINANCIAL LEVEL**

**IMPORTANT:** `mortgage_optimization` appears in ALL levels IF `user.balance.hipoteca_inmuebles > 0`

#### **Valle Profundo:**
```
Priority order:
1. saving_advice (reducir gastos)
2. better_bank_account
3. debt_review (if has debt)
4. mortgage_optimization (if has mortgage)
```

#### **Campo Base:**
```
Priority order:
1. better_bank_account
2. emergency_deposit
3. debt_review (if has debt)
4. mortgage_optimization (if has mortgage)
```

#### **Pared Vertical:**
```
Priority order:
1. better_bank_account
2. emergency_deposit
3. debt_optimization
4. mortgage_optimization (if has mortgage)
```

#### **Cresta Estable:**
```
Priority order:
1. better_bank_account
2. emergency_deposit
3. mortgage_optimization (if has mortgage)
4. [Objective-specific recommendations: ac_diposit, ac_curt, ac_llarg, ac_jubil]
```

#### **Alta Montaña:**
```
Priority order:
1. mortgage_optimization (if has mortgage)
2. better_bank_account
3. emergency_deposit
4. portfolio_optimization
5. [Objective-specific recommendations]
```

#### **Cima Conquistada:**
```
Priority order:
1. mortgage_optimization (if has mortgage)
2. better_bank_account
3. emergency_deposit
4. portfolio_optimization
5. tax_advisory
6. [Objective-specific recommendations]
```

#### **Technical implementation:**
```ruby
# User model
def financial_recommendations_ordered
  recommendations = base_financial_recommendations_ordered

  # Add objective-specific if HIGH level
  if can_invest_in_objectives?
    recommendations += objective_recommendations
  end

  recommendations.uniq
end

def base_financial_recommendations_ordered
  case financial_health_level
  when "Valle Profundo"
    recs = ["saving_advice", "better_bank_account"]
    recs << "debt_review" if total_debt > 0
    recs << "mortgage_optimization" if has_mortgage?
    recs
  when "Campo Base"
    recs = ["better_bank_account", "emergency_deposit"]
    recs << "debt_review" if total_debt > 0
    recs << "mortgage_optimization" if has_mortgage?
    recs
  when "Pared Vertical"
    recs = ["better_bank_account", "emergency_deposit", "debt_optimization"]
    recs << "mortgage_optimization" if has_mortgage?
    recs
  when "Cresta Estable"
    recs = ["better_bank_account", "emergency_deposit"]
    recs.insert(2, "mortgage_optimization") if has_mortgage?
    recs
  when "Alta Montaña"
    recs = []
    recs << "mortgage_optimization" if has_mortgage?
    recs += ["better_bank_account", "emergency_deposit", "portfolio_optimization"]
    recs
  when "Cima Conquistada"
    recs = []
    recs << "mortgage_optimization" if has_mortgage?
    recs += ["better_bank_account", "emergency_deposit", "portfolio_optimization", "tax_advisory"]
    recs
  else
    []
  end
end
```

---

### 📋 **F. RECOMMENDATION PAGES (4 Templates, 12 Pages)**

**NOTE:** We already have Recommendation model with seeds containing extensive content.

#### **Template 1: Affiliate Product (8 páginas)**
Used for:
- better_bank_account
- emergency_deposit (ac_diposit)
- ac_curt
- ac_llarg
- ac_jubil
- debt_optimization
- mortgage_optimization
- portfolio_optimization

**Structure:**
```
1. Hero
   - Título from Recommendation.title
   - Subtítulo from Recommendation.description

2. "¿Para quién es esto?"
   - Show which financial levels benefit most
   - Generic benefits (NO specific € amounts guaranteed)

3. Beneficios genéricos
   - "Reduce comisiones bancarias" (not "Ahorra €144/año")
   - "Optimiza rentabilidad" (not "Gana 3.5% vs 0%")
   - Use ranges if needed: "Entre 3-4% de rentabilidad típica"

4. CTA Afiliado #1 (prominent)
   - Button "Ver producto recomendado"
   - Links to: user.get_affiliate_link(type)

5. Contenido educativo
   - From Recommendation.content (markdown)
   - Explain what product is, how it works, considerations

6. Video Influencer (if exists)
   - Show influencer video if current_user.influencer.video_#{type}.present?

7. CTA Afiliado #2

8. FAQ específica
   - 4-5 questions about this specific product

9. "Otros usuarios también vieron" (cross-sell)
   - Show 2-3 related recommendations

10. CTA Afiliado #3 (final)

11. Social proof genérico
    - "El 67% de usuarios en Campo Base ya optimizaron su cuenta"
    - Use simulated data (credible numbers)
```

**For long-term objectives (ac_llarg, ac_jubil):**
- Add projection graph (Chart.js)
- Show difference in final amount with/without compound interest
- Example: "€200/mes durante 30 años..."
  - Sin intereses: €72,000
  - Con 8% anual: €298,000
- NO specific guarantees, use "rentabilidad histórica promedio"

#### **Template 2: Educational Only (2 páginas)**
Used for:
- debt_review
- saving_advice

**Structure:**
```
1. Hero (title + description)
2. Educational content (extensive)
3. Self-assessment quiz or checklist
4. CTA: "Volver al dashboard" or "Actualizar mis datos"
5. Internal links to other recommendations or calculators
```

**NO affiliate links** (these are purely educational).

#### **Template 3: Portfolio Optimization (1 página)**
Used for:
- portfolio_optimization

**Structure:**
```
1. Hero
2. "Analiza tu cartera actual" form
   - Campos: Platform, Amount invested, Annual fees %
   - Calculate fee impact over time
3. Comparison table (hardcoded)
   - Traditional broker: 1.5% fees
   - Recommended platform: 0.2% fees
   - Show difference on €50k, €100k, €200k over 10/20/30 years
4. CTA Afiliado (to recommended platform)
5. Educational content about index funds, ETFs, passive investing
6. FAQ
```

#### **Template 4: Tax Advisory (1 página)**
Used for:
- tax_advisory

**Structure:**
```
1. Hero
2. Educational content about tax optimization strategies
3. Basic quiz: "¿Cuánto podrías optimizar?"
   - Questions about: income level, investments, deductions
   - Generic result: "Podrías beneficiarte de asesoría fiscal"
4. CTA Afiliado (to tax advisor service)
5. Disclaimer legal: "Esto no es asesoría fiscal profesional..."
6. FAQ
```

#### **Technical implementation:**
```ruby
# RecommendationsController
def show
  @recommendation = Recommendation.find_by(slug: params[:slug])
  @user = current_user
  @affiliate_link = @user.get_affiliate_link(@recommendation.slug)

  # Template selection
  @template = case @recommendation.slug
  when 'debt_review', 'saving_advice'
    'educational'
  when 'portfolio_optimization'
    'portfolio'
  when 'tax_advisory'
    'tax'
  else
    'affiliate'
  end

  render "recommendations/#{@template}"
end
```

#### **Content Guidelines:**
- ✅ Generic benefits and ranges
- ✅ Educational and informative
- ✅ Social proof with simulated data
- ✅ Opportunity/scarcity (subtle)
- ❌ NO specific guaranteed amounts
- ❌ NO false promises
- ❌ NO testimonials (we don't have real ones)
- ❌ NO gamification (streaks, badges for visiting app)

---

### 📋 **G. EMAIL AUTOMATION (3 Types)**

#### **Email 1: Welcome Email**
**Trigger:** Immediately after user signup

**Content:**
```
Subject: ¡Bienvenido a BaiFinanzas! 🎉

Hola [nombre],

¡Gracias por registrarte en BaiFinanzas!

Estás a solo 2 pasos de recibir tu plan financiero personalizado:

1️⃣ Completa tus ingresos y gastos mensuales
2️⃣ Añade tu situación patrimonial

Una vez completo, recibirás:
✓ Tu nivel de salud financiera actual
✓ Recomendaciones personalizadas para mejorar
✓ Proyecciones de tus objetivos financieros

[CTA: Completar mi perfil →]

Un saludo,
El equipo de BaiFinanzas
```

**Technical:**
```ruby
# User model - after_create callback
after_create :send_welcome_email

def send_welcome_email
  UserMailer.welcome_email(self).deliver_later
end
```

#### **Email 2: Complete Profile Series**
**Trigger:** User registered but hasn't completed PyG or Balance

**Series:** 3 emails at days 1, 3, 7 after signup

**Email 2.1 (Day 1):**
```
Subject: Falta poco para tu plan personalizado ⏱️

Hola [nombre],

Veo que empezaste a crear tu perfil financiero pero aún no lo has completado.

Solo te faltan [X minutos] para recibir:
✓ Tu diagnóstico financiero completo
✓ Recomendaciones personalizadas
✓ Plan de acción específico

[CTA: Completar ahora →]

¿Necesitas ayuda? Responde este email.

Un saludo,
El equipo de BaiFinanzas
```

**Email 2.2 (Day 3):**
```
Subject: ¿Necesitas ayuda para completar tu perfil? 🤔

Hola [nombre],

Sabemos que completar datos financieros puede parecer tedioso,
pero son solo 2 minutos y el resultado vale la pena.

Miles de usuarios ya mejoraron su situación financiera con BaiFinanzas.

[CTA: Completar mi perfil →]

Si tienes dudas, estamos aquí para ayudarte.

Un saludo,
El equipo de BaiFinanzas
```

**Email 2.3 (Day 7):**
```
Subject: Última oportunidad: Tu plan te espera 📊

Hola [nombre],

Este es nuestro último recordatorio.

Tu plan financiero personalizado está esperándote, pero necesitamos
que completes tu perfil primero.

[CTA: Completar ahora →]

Si no quieres recibir más emails, puedes darte de baja aquí.

Un saludo,
El equipo de BaiFinanzas
```

**Technical:**
```ruby
# Rake task (run daily via cron/scheduler)
# lib/tasks/send_incomplete_profile_emails.rake

task send_incomplete_profile_emails: :environment do
  # Day 1 email
  users_day_1 = User.where("created_at >= ? AND created_at < ?", 1.day.ago, 23.hours.ago)
                    .joins(:pyg).where(pygs: { ingresos_mensual: 0 })
  users_day_1.each { |u| UserMailer.incomplete_profile_day_1(u).deliver_later }

  # Day 3 email
  users_day_3 = User.where("created_at >= ? AND created_at < ?", 3.days.ago, 71.hours.ago)
                    .joins(:pyg).where(pygs: { ingresos_mensual: 0 })
  users_day_3.each { |u| UserMailer.incomplete_profile_day_3(u).deliver_later }

  # Day 7 email
  users_day_7 = User.where("created_at >= ? AND created_at < ?", 7.days.ago, 167.hours.ago)
                    .joins(:pyg).where(pygs: { ingresos_mensual: 0 })
  users_day_7.each { |u| UserMailer.incomplete_profile_day_7(u).deliver_later }
end
```

#### **Email 3: Quarterly Update Reminder**
**Trigger:** 3 months after last PyG/Balance update

**Content:**
```
Subject: ¿Ha cambiado tu situación financiera? 📈

Hola [nombre],

Han pasado 3 meses desde que actualizaste tus datos en BaiFinanzas.

En este tiempo, tu situación puede haber mejorado (¡esperamos que sí!)
o cambiado. Actualizar tus datos te permitirá:

✓ Ver si has subido de nivel financiero
✓ Recibir nuevas recomendaciones personalizadas
✓ Ajustar tus objetivos si es necesario

Solo te tomará 5 minutos:

[CTA: Actualizar mis datos →]

Un saludo,
El equipo de BaiFinanzas

P.D. Si tu situación no ha cambiado, puedes ignorar este email.
```

**Technical:**
```ruby
# Rake task (run monthly via cron/scheduler)
# lib/tasks/send_quarterly_update_reminders.rake

task send_quarterly_update_reminders: :environment do
  # Find users whose PyG or Balance was updated 3+ months ago
  users = User.joins(:pyg, :balance)
              .where("pygs.updated_at < ? OR balances.updated_at < ?", 3.months.ago, 3.months.ago)
              .where.not(pygs: { ingresos_mensual: 0 }) # Only users with complete profile

  users.each do |user|
    UserMailer.quarterly_update_reminder(user).deliver_later
  end
end
```

**Email service setup:**
- Use Postmark or SendGrid
- Configure Action Mailer in production
- Add unsubscribe link to all emails (legal requirement)
- Track open/click rates (optional, if easy)

---

### 📋 **H. SAVINGS CAPACITY & OBJECTIVES (Already in Phase 3)**

These features are already implemented in Phase 3:
- ✅ Objective model with compound interest calculations
- ✅ Investment recommendation per objective (ac_diposit, ac_curt, ac_llarg, ac_jubil)
- ✅ Monthly savings needed calculation
- ✅ Savings capacity analysis

**Enhancements needed for Phase 4:**
- Savings capacity widget with 3 visual states (healthy/high/exceeded)
- Objective cards with 3 states (new/on-track/off-track)
- Preventive validation when creating objectives
- Deficit alert in dashboard
- Modal to adjust objectives when capacity exceeded
- Objectives show page with detailed charts and calculators

---

## 🎨 Design System

### Visual Hierarchy by User Level:

**LOW LEVEL (Valle/Campo/Pared):**
1. Header (level + last update)
2. Card "Next Level" (what's missing to level up)
3. 📋 BASE Recommendations (checklist) ← MAIN FOCUS
4. 🔒 "Unlock objectives by reaching Cresta Estable"
5. 📊 PyG + Balance Analysis (collapsible)

**HIGH LEVEL (Cresta/Alta/Cima):**
1. Header (level + last update + notifications)
2. 🎉 "UNLOCKED! Plan your future" (first time only)
3. 📋 BASE Recommendations (collapsible, less prominent)
4. 💰 Savings Capacity Widget
5. 🎯 Personalized OBJECTIVES ← MAIN FOCUS (80% attention)
6. 📊 PyG + Balance Analysis (collapsible)

### Color System:
```
Green (#1EDD88)  → Completed, positive, main CTA, objectives
Blue (#0D6EFD)   → Current level, information, base recommendations
Yellow (#FFC65A) → Warning, high capacity usage
Red (#FD1015)    → Negative, deficit, delete
Gray (#6c757d)   → Disabled, secondary
```

**Application:**
- Green checkboxes when completed
- € amounts always in green (benefit)
- Time in blue (information)
- Main action buttons in green
- Capacity bars: green/yellow/red by %

### Mobile-First Priorities:

**Dashboard mobile shows:**
1. "Next Level" card (sticky top optional)
2. Capacity widget (if has objectives)
3. First most important action/objective
4. "View all" button (expand list)

**Hide on mobile by default:**
- Full mountain progress (takes too much space)
- Detailed charts (hard to read) → Link to show page
- Long forms → Use modal instead

---

## 📊 Success Metrics

**Measurable goals:**
- Profile completion rate: **30% → 60%**
- Users mark action completed: **0% → 40%**
- Affiliate clicks: **5% → 15%**
- Users return in 30 days: **10% → 30%**
- Time to first action: **never → 3 days average**

---

## 🚀 Implementation Roadmap (4 Weeks: Oct 20 - Nov 14, 2024)

### **SEMANA 1: Influencer System + Onboarding + Homepage**
**Objetivo:** Sistema de influencers operativo + Onboarding completo + Homepage finalizada

**Tareas:**
1. **Influencer System**
   - ✅ Añadir Devise authentication a Influencer model
   - ✅ Añadir 8 campos de video (string URLs): video_compte, video_cdiposit, video_curt, video_llarg, video_deute, video_jubil, video_fiscal, video_portfolio
   - ✅ Generar código único automático en `after_create`: `"#{name.parameterize}-#{SecureRandom.hex(4)}"`
   - ✅ Crear vista login influencer (`/influencers/sign_in`)
   - ✅ Dashboard influencer con código y enlace copiable
   - ✅ UTM tracking en ApplicationController (cookie 30 días + session)
   - ✅ Guardar `influencer_id` en User al signup si UTM existe

2. **Onboarding Flow**
   - ✅ Página welcome después de signup (`/welcome`)
   - ✅ Embed PyG form en welcome (progress 50%)
   - ✅ Redirect a Balance form después de PyG (progress 100%)
   - ✅ Loading screen con animación 5 segundos
   - ✅ Redirect a Dashboard complete después de loading

3. **Homepage Final**
   - ✅ Hero con headline: "Tu plan financiero personalizado - 100% gratis"
   - ✅ Subtítulo opción 4 aprobado
   - ✅ Secciones: ¿Cómo funciona?, Niveles financieros, Beneficios, FAQ, CTA final
   - ✅ UTM tracking en todos los CTAs
   - ✅ Mobile-first responsive

4. **Testing Semana 1**
   - ✅ Probar flujo completo: Landing → UTM → Signup → Onboarding → Dashboard
   - ✅ Verificar tracking influencer funciona correctamente
   - ✅ Ajustes mobile-first
   - ✅ Fix bugs encontrados

**Estado al final:** Sistema influencers + onboarding + homepage operativos

---

### **SEMANA 2: Dashboard Rediseñado (LOW + HIGH)**
**Objetivo:** Dashboard diferenciado por nivel financiero operativo

**Tareas:**
1. **Dashboard LOW Levels (Valle, Campo, Pared)**
   - ✅ Card "Próximo nivel" (requirements checker)
   - ✅ Implementar `financial_recommendations_ordered` en User model
   - ✅ Reordenar recomendaciones por prioridad según nivel (ver sección E)
   - ✅ `mortgage_optimization` aparece en TODOS los niveles si `balance.hipoteca > 0`
   - ✅ Mostrar primera acción destacada (Proposition A)
   - ✅ Beneficios genéricos por recomendación (NO números concretos garantizados)
   - ✅ Social proof genérico: "X% de usuarios en tu nivel ya hicieron esto"
   - ✅ Sección "🔒 Desbloquea objetivos" (placeholder)

2. **Dashboard HIGH Levels (Cresta, Alta, Cima)**
   - ✅ Widget capacidad de ahorro con 3 estados (healthy <70% / high 70-90% / exceeded >100%)
   - ✅ Reordenar recomendaciones por prioridad (mortgage first si existe)
   - ✅ Sección objetivos con cards (3 estados: new/on-track/off-track)
   - ✅ Modal ajuste objetivos si déficit de capacidad
   - ✅ Validación preventiva al crear objetivo
   - ✅ Gráficos proyección objetivos (Chart.js)

3. **Common Dashboard Elements**
   - ✅ Header con nivel actual
   - ✅ Badge "Última actualización hace X días"
   - ✅ PyG + Balance analysis colapsable (accordion)
   - ✅ Botón "Actualizar datos"
   - ✅ Responsive mobile-first

4. **Testing Semana 2**
   - ✅ Probar dashboard en los 6 niveles financieros
   - ✅ Probar con/sin hipoteca (mortgage_optimization aparece correctamente)
   - ✅ Probar con/sin objetivos
   - ✅ Probar déficit de capacidad
   - ✅ Verificar todos los cálculos

**Estado al final:** Dashboard completo diferenciado LOW vs HIGH

---

### **SEMANA 3: Páginas de Recomendaciones (12 páginas, 4 templates)**
**Objetivo:** 12 páginas de recomendación operativas con 4 templates diferentes

**Tareas:**
1. **Template 1: Affiliate Product (8 páginas)**
   - ✅ Layout común para: better_bank_account, emergency_deposit, ac_curt, ac_llarg, ac_jubil, debt_optimization, mortgage_optimization, portfolio_optimization
   - ✅ Estructura completa (ver sección F):
     - Hero (título + subtítulo from Recommendation model)
     - "¿Para quién es esto?" (niveles que benefician)
     - Beneficios genéricos (NO números concretos)
     - CTA afiliado prominente (3 ubicaciones)
     - Contenido educativo from Recommendation.content
     - Video influencer si existe
     - FAQ específica
     - "Otros usuarios también vieron" (cross-sell)
     - Social proof genérico
   - ✅ Enlace afiliado desde `user.get_affiliate_link(type)`
   - ✅ Para ac_llarg y ac_jubil: añadir gráfico proyección (Chart.js)

2. **Template 2: Educational Only (2 páginas)**
   - ✅ Para: debt_review, saving_advice
   - ✅ Sin afiliado, contenido educativo extenso
   - ✅ Self-assessment quiz o checklist
   - ✅ CTAs: "Volver a dashboard" o "Actualizar mis datos"
   - ✅ Enlaces internos a otras recomendaciones

3. **Template 3: Portfolio Optimization (1 página)**
   - ✅ Formulario análisis cartera
   - ✅ Comparador comisiones (hardcoded: 1.5% vs 0.2%)
   - ✅ Gráfico impacto comisiones en €50k, €100k, €200k a 10/20/30 años
   - ✅ CTA afiliado a plataforma recomendada
   - ✅ Contenido educativo sobre fondos indexados, ETFs

4. **Template 4: Tax Advisory (1 página)**
   - ✅ Contenido educativo optimización fiscal
   - ✅ Quiz básico situación fiscal
   - ✅ CTA afiliado asesor fiscal
   - ✅ Disclaimer legal

5. **Testing Semana 3**
   - ✅ Probar las 12 páginas
   - ✅ Verificar enlaces afiliados correctos por tipo
   - ✅ Verificar videos influencer aparecen si existen
   - ✅ Mobile responsive
   - ✅ SEO básico (meta tags)

**Estado al final:** 12 páginas recomendación operativas

---

### **SEMANA 4: Email Automation + Testing Final + Deploy**
**Objetivo:** Emails automáticos operativos + App testeada completamente + Deploy a producción

**Tareas:**
1. **Email Automation (3 tipos)**
   - ✅ **Email 1: Bienvenida** (trigger: after_create en User)
     - Setup mailer + template HTML
     - CTA: "Completa tu perfil"
   - ✅ **Email 2: Complete Profile Series** (3 emails: días 1, 3, 7)
     - Crear rake task que corre diariamente
     - 3 templates diferentes (ver sección G)
     - Trigger: users con PyG incompleto
   - ✅ **Email 3: Quarterly Update** (trigger: 3 meses sin actualizar)
     - Crear rake task que corre mensualmente
     - Template reminder actualización
   - ✅ Configurar Postmark o SendGrid
   - ✅ Action Mailer configuration en production
   - ✅ Unsubscribe link en todos los emails

2. **Testing Completo App**
   - ✅ Signup con UTM → influencer asignado correctamente
   - ✅ Signup sin UTM → influencer = nil
   - ✅ Onboarding flow completo (5 pasos)
   - ✅ Dashboard LOW: 3 niveles (Valle, Campo, Pared)
   - ✅ Dashboard HIGH: 3 niveles (Cresta, Alta, Cima)
   - ✅ Con/sin hipoteca muestra mortgage_optimization correctamente
   - ✅ Crear objetivo: validación capacidad funciona
   - ✅ Objetivo excede capacidad → modal ajuste funciona
   - ✅ 12 páginas recomendación funcionan
   - ✅ Enlaces afiliados correctos por tipo
   - ✅ Videos influencer aparecen si existen
   - ✅ Emails enviados en momentos correctos
   - ✅ Mobile responsive (iPhone SE, iPhone 12, iPad)
   - ✅ Desktop responsive (1920px, 1366px, 1024px)

3. **Ajustes Finales + Deploy**
   - ✅ Fix bugs encontrados en testing
   - ✅ Optimización performance (N+1 queries con bullet gem)
   - ✅ Seeds final con datos demo
   - ✅ Deploy a producción (Heroku/Render/Railway)
   - ✅ Configurar dominio + SSL certificate
   - ✅ Monitoring básico (Sentry o Rollbar)
   - ✅ Google Analytics configurado

**Estado al final:** App 100% operativa en producción

---

## ✅ Checklist Final (14 Nov 2024)

Antes de considerar la app "operativa" para lanzamiento:

**Influencer System:**
- [ ] Usuario puede registrarse con UTM y se asigna influencer correctamente
- [ ] Usuario puede registrarse sin UTM (influencer = nil)
- [ ] Influencer puede hacer login en `/influencers/sign_in`
- [ ] Dashboard influencer muestra código y enlace copiable

**Onboarding:**
- [ ] Flujo completo funciona: Signup → Welcome → PyG → Balance → Loading → Dashboard
- [ ] Progress bars muestran correctamente (0% → 50% → 100%)
- [ ] Loading screen 5 segundos con animación

**Homepage:**
- [ ] Headline y subtítulo aprobados
- [ ] 6 secciones completas
- [ ] UTM tracking en todos los CTAs
- [ ] Mobile-first responsive

**Dashboard:**
- [ ] Muestra correctamente 6 niveles financieros
- [ ] LOW levels: recomendaciones ordenadas por prioridad
- [ ] HIGH levels: widget capacidad + objetivos
- [ ] `mortgage_optimization` aparece en TODOS los niveles si tiene hipoteca
- [ ] Card "Próximo nivel" funciona
- [ ] PyG + Balance analysis colapsable

**Objetivos:**
- [ ] Crear objetivo: validación capacidad funciona
- [ ] Modal ajuste cuando capacidad excedida
- [ ] 3 estados de cards (new/on-track/off-track)
- [ ] Gráficos proyección (Chart.js)

**Recommendation Pages:**
- [ ] 12 páginas accesibles
- [ ] 4 templates diferentes funcionan
- [ ] Enlaces afiliados correctos por tipo
- [ ] Videos influencer aparecen si existen
- [ ] Gráficos para ac_llarg y ac_jubil

**Email Automation:**
- [ ] Email bienvenida se envía after signup
- [ ] Serie 3 emails perfil incompleto (días 1, 3, 7)
- [ ] Email quarterly update (3 meses)
- [ ] Unsubscribe link funciona

**Responsive:**
- [ ] Mobile 100% funcional (iPhone SE, iPhone 12)
- [ ] Tablet funcional (iPad)
- [ ] Desktop funcional (1920px, 1366px, 1024px)

**Production:**
- [ ] Deploy en producción estable
- [ ] Dominio configurado + SSL
- [ ] Analytics funcionando
- [ ] Monitoring funcionando

---

## 📅 Timeline Visual

```
┌──────────────────────────────────────────────────────────┐
│                    4 SEMANAS INTENSIVAS                  │
│             20 Octubre - 14 Noviembre 2024               │
└──────────────────────────────────────────────────────────┘

SEMANA 1 (Oct 20-26)
├─ Influencer System (Devise + UTM tracking)
├─ Onboarding Flow (5 pasos + loading)
├─ Homepage Final (headline + secciones)
└─ Testing flujo completo

SEMANA 2 (Oct 27 - Nov 2)
├─ Dashboard LOW (Valle, Campo, Pared)
├─ Dashboard HIGH (Cresta, Alta, Cima)
├─ Capacidad ahorro widget
└─ Testing 6 niveles + objetivos

SEMANA 3 (Nov 3-9)
├─ Template 1: Affiliate (8 páginas)
├─ Template 2: Educational (2 páginas)
├─ Template 3: Portfolio (1 página)
├─ Template 4: Tax (1 página)
└─ Testing 12 páginas

SEMANA 4 (Nov 10-14)
├─ Email automation (3 tipos)
├─ Testing completo app
├─ Ajustes finales
└─ Deploy producción

🎯 Nov 14: APP OPERATIVA
📅 Nov 15-30: Ajustes finales
🚀 Dec 1, 2025: LANZAMIENTO OFICIAL
```

---

## 💡 Consideraciones Importantes

**Con AI Support:**
- Desarrollo 2-3x más rápido que tradicional
- Código boilerplate automático
- Testing cases generados
- Debugging asistido

**Riesgos:**
- ⚠️ Timeline ajustado (no hay margen error)
- ⚠️ Testing debe ser exhaustivo
- ⚠️ Decisiones rápidas cuando haya dudas técnicas

**Mitigación:**
- ✅ Comenzar exactamente Oct 20
- ✅ Sesiones diarias de desarrollo
- ✅ Testing continuo (no solo al final)
- ✅ Deploy incremental a staging cada semana

---

## 🎯 Próximos Pasos (Después del 14 Nov)

**Nov 15 - Nov 30: Ajustes Pre-Lanzamiento**
- Fix bugs reportados por testing
- Optimizaciones performance
- Ajustes copy/contenido
- Preparar materiales marketing
- Contactar primeros influencers

**Dec 1, 2025: Lanzamiento Soft**
- Lanzamiento a primeros influencers (beta testers)
- Monitoreo intensivo errores
- Feedback users tempranos
- Ajustes rápidos si necesario

**Phase 5: Post-Launch (Future)**
- Multi-calculator system (SEO long-tail)
- Notification system
- Analytics dashboard influencers
- A/B testing CTAs
- Expansion features based on feedback

---

## 🔧 Technical Changes Required

### New Database Tables:

```ruby
# user_actions - Track completed actions
create_table :user_actions do |t|
  t.references :user, null: false, foreign_key: true
  t.string :action_type, null: false
  t.decimal :saving_amount
  t.integer :time_spent
  t.timestamp :completed_at
  t.timestamps
end

# notifications - Notification system
create_table :notifications do |t|
  t.references :user, null: false, foreign_key: true
  t.string :type, null: false
  t.boolean :read, default: false
  t.jsonb :metadata
  t.timestamps
end

# objective_history - Track objective adjustments
create_table :objective_histories do |t|
  t.references :objective, null: false, foreign_key: true
  t.string :field_changed
  t.string :old_value
  t.string :new_value
  t.timestamp :changed_at
  t.timestamps
end
```

### New User Model Methods:

```ruby
# Savings capacity
def monthly_savings_capacity
def can_afford_objective?(monthly_amount)
def objectives_deficit

# Recommendation benefits (calculate specific € savings)
def better_bank_account_benefit
def debt_optimization_benefit
def emergency_deposit_benefit
def saving_advice_benefit
def mortgage_optimization_benefit
def portfolio_optimization_benefit
def tax_advisory_benefit

# Recommendations with benefits
def recommendations_with_benefits
```

### New Objective Model Methods:

```ruby
# Validations
def validates_against_user_capacity
def suggest_adjustments_if_unaffordable

# Status checks
def on_track?
def off_track?
def deficit_amount
```

---

## ✂️ Elements to Remove/Reduce

**❌ Remove:**
- Full mountain progress visualization at top (replace with "Next Level" card)
- Animated arrow between sections
- Inline objective creation form (move to modal/expandable section)

**📦 Collapse (hide by default):**
- PyG + Balance charts (expandable accordion)
- BASE recommendations (if Cresta+ user with active objectives)
- Detailed financial analysis (button "See full analysis")

---

## Technical Implementation Details

### Financial Health Calculation
- Investment income calculation: 0.5% on cash + 4% on investments + 1.5% on real estate
- Emergency fund target: 4 months of expenses
- Debt-free criteria: debt-to-assets ≤15% OR total debt ≤2x annual income

### Key Models & Methods
- `User#financial_health_level` - Returns current health level
- `User#financial_recommendations` - Returns array of recommendation strings
- `User#recommendations_with_links` - Returns recommendations with affiliate URLs
- `Objective#monthly_savings_needed` - Compound interest calculation
- `Objective#investment_recommendation` - Returns appropriate product code
- `Objective#savings_capacity_analysis` - Checks if user can afford monthly savings

### Testing Status
- ✅ All financial engine components tested and working
- ✅ Multiple scenarios tested (different health levels, objectives, affiliate links)
- ✅ Compound interest calculations verified
- ✅ Savings capacity analysis working

---

## Technical Notes
- Rails 7.2.2.1 application
- Models: User, Balance, Pyg, Objective, Influencer, Recommendation
- User automatically gets default Balance and Pyg records on signup
- Objective status: pending, active, completed, cancelled
- All calculations handle edge cases (missing data, zero values)
- Dashboard has 3 states based on user data completion
- Recommendation pages support objective context via query params
