# BaiFinanzas Development Progress

## Project Overview
Financial platform with influencer referral system focused on helping users achieve financial health through personalized recommendations and investment guidance.

## 🎯 Business Objectives
1. **Help users improve their financial situation** - Answer "what can I do in my specific situation?"
2. **Drive engagement** - Get users to complete all their financial information
3. **Increase recurrence** - Users return to update status and receive new recommendations
4. **Monetize with affiliates** - Convert recommendations into affiliate clicks and signups

---

## Development Status

### ✅ PHASE 1: Core Foundation - COMPLETED
1. ✅ Mobile-first responsive design
2. ✅ Landing page components (hero, features, FAQ, CTA)
3. ✅ User authentication (Devise)
4. ✅ Basic form validation

### ✅ PHASE 2: Financial Engine - COMPLETED
5. ✅ **Financial scoring system** - 6-level health system:
   - "Situación Crítica" → Negative/minimal cash flow
   - "Creando Fondo de Emergencia" → Building emergency fund (positive cash flow)
   - "Eliminando Deudas Caras" → Paying off expensive debt + partial emergency fund
   - "Situación Estable" → Has emergency fund, no expensive debt, positive cash flow
   - "Crecimiento Patrimonial" → Net worth ≥ 2x annual income
   - "Libertad Financiera" → Investment income ≥ monthly expenses

6. ✅ **Recommendation engine**
   - Base recommendations per financial level
   - Objective-specific investment recommendations
   - Affiliate link integration

7. ✅ **Compound interest calculator**
   - Short-term (0-2 years): 1.5% return → `ac_diposit`
   - Medium-term (2-5 years): 3% return → `ac_curt`
   - Long-term (5+ years): 8% return → `ac_llarg`
   - Retirement: 8% return → `ac_jubil`
   - Monthly savings needed with compound interest

8. ✅ **Affiliate links**
   - Influencer model with affiliate URL fields (ac_compte, ac_cdiposit, ac_curt, ac_llarg, ac_deute, ac_jubil, ac_fiscal)
   - `User.get_affiliate_link(product_type)` method

### ✅ PHASE 3: Dashboard & Core Features - COMPLETED
9. ✅ **Dashboard system** - 3-state dashboard
   - State 1: New user (PyG form embedded)
   - State 2: Has PyG data (Balance form + PyG analysis)
   - State 3: Complete dashboard (Financial health + Plan Financiero)

10. ✅ **Objectives management**
    - Create/delete objectives
    - Monthly savings calculations with compound interest
    - Investment recommendation per objective
    - Automatic icon assignment based on title keywords
    - Savings capacity analysis

11. ✅ **Influencer System**
    - Devise authentication for influencers
    - UTM tracking (cookie + session)
    - Influencer dashboard with unique code
    - 8 video fields: video_compte, video_cdiposit, video_curt, video_llarg, video_deute, video_jubil, video_fiscal, video_portfolio
    - Auto-assign influencer to user on signup via UTM

12. ✅ **Plan Financiero (Action Plan)**
    - Unified action plan combining base recommendations + user objectives
    - User can complete/uncomplete actions (persisted in user_actions table)
    - Numbered tasks (1, 2, 3...)
    - Bootstrap icons for each task type
    - Visual states: normal, hover, completed, is-next
    - Clean card design:
      - Sidebar: numbered list with task icons and titles
      - Main area: detail content for selected task
    - Task types:
      - `recommendation` - Base financial recommendations
      - `objective` - User's personalized objectives
      - `create_objective` - Option to create new objective

13. ✅ **Recommendation Model & Data**
    - Recommendation model with: slug, title, description, content (markdown)
    - Seeds with extensive content for 12 recommendation types
    - RecommendationsController with show action
    - Routes: `/recommendations/:slug`

---

## 🚀 PHASE 4: Beta Launch Preparation (CURRENT)

### **Status: ~80% Complete**

Only 2 critical tasks remain for Beta launch:

### **📋 TASK 1: Recommendation Pages (12 páginas)**
**Status:** ⬜ Not implemented

Create 12 recommendation detail pages using 4 different templates:

#### **Template 1: Affiliate Product (8 páginas)**
Used for: `better_bank_account`, `emergency_deposit`, `ac_curt`, `ac_llarg`, `ac_jubil`, `debt_optimization`, `mortgage_optimization`, `portfolio_optimization`

**Structure:**
```
1. Hero
   - Title from Recommendation.title
   - Subtitle from Recommendation.description

2. "¿Para quién es esto?"
   - Show which financial levels benefit most
   - Generic benefits (NO specific € guaranteed amounts)

3. Beneficios genéricos
   - "Reduce comisiones bancarias" (not "Ahorra €144/año")
   - "Optimiza rentabilidad" (not "Gana 3.5% vs 0%")
   - Use ranges if needed: "Entre 3-4% de rentabilidad típica"

4. CTA Afiliado #1 (prominent)
   - Button "Ver producto recomendado"
   - Link: current_user.get_affiliate_link(recommendation_type)

5. Contenido educativo
   - From Recommendation.content (markdown)
   - Explain product, how it works, considerations

6. Video Influencer (if exists)
   - Show if current_user.influencer.video_#{type}.present?
   - Embedded iframe

7. CTA Afiliado #2

8. FAQ específica
   - 4-5 questions about this specific product

9. CTA Afiliado #3 (final)
```

**Special case for long-term (ac_llarg, ac_jubil):**
- Add projection graph (Chart.js)
- Show compound interest effect
- Example: "€200/mes durante 30 años..."
  - Sin intereses: €72,000
  - Con 8% anual: €298,000
- NO guarantees, use "rentabilidad histórica promedio"

#### **Template 2: Educational Only (2 páginas)**
Used for: `debt_review`, `saving_advice`

**Structure:**
```
1. Hero (title + description)
2. Educational content (extensive) from Recommendation.content
3. Self-assessment quiz or checklist
4. CTA: "Volver al dashboard"
5. Internal links to other recommendations
```

**NO affiliate links** (purely educational).

#### **Template 3: Portfolio Optimization (1 página)**
Used for: `portfolio_optimization`

**Structure:**
```
1. Hero
2. "Analiza tu cartera actual" form
   - Fields: Platform, Amount invested, Annual fees %
   - Calculate fee impact over time
3. Comparison table (hardcoded)
   - Traditional broker: 1.5% fees
   - Recommended platform: 0.2% fees
   - Show difference on €50k, €100k, €200k over 10/20/30 years
4. CTA Afiliado
5. Educational content about index funds, ETFs, passive investing
6. FAQ
```

#### **Template 4: Tax Advisory (1 página)**
Used for: `tax_advisory`

**Structure:**
```
1. Hero
2. Educational content about tax optimization strategies
3. Basic quiz: "¿Cuánto podrías optimizar?"
   - Questions about: income level, investments, deductions
   - Generic result: "Podrías beneficiarte de asesoría fiscal"
4. CTA Afiliado
5. Disclaimer legal: "Esto no es asesoría fiscal profesional..."
6. FAQ
```

#### **Technical Implementation:**
```ruby
# app/controllers/recommendations_controller.rb
def show
  @recommendation = Recommendation.find_by!(slug: params[:slug])
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

**Routes:**
```ruby
# config/routes.rb
resources :recommendations, only: [:show], param: :slug
# Results in: /recommendations/better-bank-account, /recommendations/ac-llarg, etc.
```

**Views to create:**
```
app/views/recommendations/
  ├── affiliate.html.erb
  ├── educational.html.erb
  ├── portfolio.html.erb
  └── tax.html.erb
```

---

### **📋 TASK 2: Plan Financiero - Main Content Area Design**
**Status:** ⬜ Partially implemented

The sidebar (left) with task list is complete. Need to design the main content area (right) that shows when user clicks a task.

#### **What exists now:**
- ✅ Sidebar with numbered task list
- ✅ Click on task selects it (JavaScript)
- ⬜ Main area just shows "placeholder" content

#### **What's needed:**
Design 3 different content layouts for the main area:

#### **Layout A: Base Recommendation**
When user clicks a `recommendation` task, show:

```
┌─────────────────────────────────────────┐
│ [Icon] Recommendation Title             │
│                                         │
│ Brief description (1-2 líneas)          │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                         │
│ ¿Por qué es importante?                 │
│ • Benefit 1 (generic)                   │
│ • Benefit 2 (generic)                   │
│ • Benefit 3 (generic)                   │
│                                         │
│ [Button: Ver detalles completos →]     │
│ (links to /recommendations/slug)        │
│                                         │
│ [Button: Marcar como completada ✓]     │
│ (or "Desmarcar" if already completed)   │
└─────────────────────────────────────────┘
```

**Data source:**
- Title: `recommendation_title(rec_key)`
- Icon: `recommendation_icon(rec_key)`
- Description: `recommendation_benefit_text(rec_key)` (already exists)
- Benefits: Can be hardcoded or added to Recommendation model

#### **Layout B: User Objective**
When user clicks an `objective` task, show:

```
┌─────────────────────────────────────────┐
│ [Icon] Objective Title                  │
│                                         │
│ Meta: €X,XXX en X meses                 │
│                                         │
│ [Progress bar] XX%                      │
│ €X,XXX / €X,XXX                         │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                         │
│ Tu plan de ahorro:                      │
│ • Ahorrar: €XXX/mes                     │
│ • Producto recomendado: [name]          │
│ • Rentabilidad esperada: X%             │
│ • Fecha objetivo: DD/MM/YYYY            │
│                                         │
│ [Button: Ver proyección completa →]    │
│ (future: links to /objectives/:id)      │
│                                         │
│ [Button: Ajustar objetivo]              │
│ [Button: Eliminar objetivo]             │
└─────────────────────────────────────────┘
```

**Data source:**
- All data from `objective` object in action_plan
- Icon: `objective.objective_icon`
- Title: `objective.title`
- Amounts: `objective.target_amount`, `objective.monthly_savings_needed`
- Recommendation: `objective.investment_recommendation`

#### **Layout C: Create Objective**
When user clicks `create_objective` task, show:

```
┌─────────────────────────────────────────┐
│ [Icon] Crear nuevo objetivo             │
│                                         │
│ Define tu próxima meta financiera       │
│                                         │
│ ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │
│                                         │
│ [Form inline o modal]                   │
│ • Título del objetivo                   │
│ • Cantidad objetivo (€)                 │
│ • Fecha objetivo                        │
│                                         │
│ [Button: Crear objetivo →]              │
│                                         │
│ Ejemplos de objetivos:                  │
│ • Comprar un coche                      │
│ • Viaje de vacaciones                   │
│ • Educación de tus hijos                │
│ • Fondo de emergencia                   │
└─────────────────────────────────────────┘
```

**Implementation approach:**
Option 1: Inline form in main area
Option 2: Button "Crear objetivo" opens modal (cleaner)

#### **Technical Implementation:**

JavaScript to update main content when task is selected:

```javascript
function selectStep(stepId) {
  // Find the action in actionPlanData
  const action = actionPlanData.find(a => a.position === stepId);

  // Update main content based on action type
  if (action.type === 'recommendation') {
    displayRecommendationContent(action);
  } else if (action.type === 'objective') {
    displayObjectiveContent(action);
  } else if (action.type === 'create_objective') {
    displayCreateObjectiveContent(action);
  }
}

function displayRecommendationContent(action) {
  const mainContent = document.getElementById('plan-main-content');
  mainContent.innerHTML = `
    <div class="task-detail">
      <div class="task-header">
        <i class="${action.icon}"></i>
        <h2>${action.title}</h2>
      </div>
      <p class="task-description">${action.benefit_text}</p>

      <hr>

      <h4>¿Por qué es importante?</h4>
      <ul>
        <li>${getBenefit1(action.key)}</li>
        <li>${getBenefit2(action.key)}</li>
        <li>${getBenefit3(action.key)}</li>
      </ul>

      <div class="task-actions">
        <a href="/recommendations/${action.slug}" class="btn btn-primary">
          Ver detalles completos →
        </a>
        <button onclick="toggleAction('${action.key}', 'recommendation', ${action.completed})"
                class="btn btn-success">
          ${action.completed ? 'Desmarcar ✗' : 'Marcar como completada ✓'}
        </button>
      </div>
    </div>
  `;
}

function displayObjectiveContent(action) {
  // Similar structure for objectives
}

function displayCreateObjectiveContent(action) {
  // Form or button to open modal
}
```

**CSS Styling:**
- Clean, simple design matching dashboard style
- Prominent CTA buttons
- Mobile responsive
- Good spacing and readability

---

## Beta Launch Checklist

Once Task 1 and Task 2 are complete:

### **Testing:**
- [ ] Test all 12 recommendation pages
- [ ] Test all 3 main content layouts
- [ ] Test affiliate links work correctly
- [ ] Test influencer videos appear if they exist
- [ ] Test complete/uncomplete actions persist correctly
- [ ] Test mobile responsive (iPhone SE, iPhone 12, iPad)
- [ ] Test desktop responsive (1920px, 1366px)
- [ ] Test all 6 financial levels show correct recommendations
- [ ] Test with/without objectives
- [ ] Test with/without influencer assigned

### **Content:**
- [ ] Verify all Recommendation.content is filled (seeds)
- [ ] Verify all affiliate links are correct URLs
- [ ] Add FAQ content for each recommendation page

### **Deploy:**
- [ ] Deploy to production (Heroku/Render/Railway)
- [ ] Configure domain + SSL certificate
- [ ] Test production environment
- [ ] Set up basic monitoring (Sentry/Rollbar)
- [ ] Configure Google Analytics

### **🎯 Beta Launch Ready!**

---

## PHASE 5: Post-Launch Improvements (Future)

### **Not critical for Beta, implement after launch:**

1. **Onboarding Flow Enhancement**
   - Welcome page after signup
   - Progress bars (0% → 50% → 100%)
   - Loading screen with animation
   - Better redirect logic

2. **Email Automation**
   - Welcome email after signup
   - Incomplete profile reminder series (days 1, 3, 7)
   - Quarterly update reminder (3 months)
   - Configure Postmark/SendGrid

3. **Homepage Redesign**
   - Updated headline: "Tu plan financiero personalizado - 100% gratis"
   - New sections: ¿Cómo funciona?, Niveles financieros, Beneficios
   - Better CTAs with UTM tracking

4. **Dashboard Enhancements**
   - "Próximo nivel" card (shows requirements to level up)
   - Badge "Última actualización hace X días"
   - Collapsible PyG + Balance analysis (accordion)
   - Different layouts for LOW vs HIGH financial levels

5. **Savings Capacity Widget**
   - Visual states: healthy (<70%), high (70-90%), exceeded (>100%)
   - Alerts when objectives exceed capacity
   - Modal to adjust objectives

6. **Objective Detail Pages**
   - Individual page per objective (/objectives/:id)
   - Investment evolution chart
   - Month-by-month breakdown
   - Interactive calculator
   - "What if" simulator

7. **Advanced Features**
   - Multi-calculator system (SEO long-tail)
   - Notification system
   - Social proof with real data
   - A/B testing CTAs
   - Analytics dashboard for influencers

---

## Technical Notes

### **Models:**
- `User` - Devise authentication, belongs_to influencer (optional)
- `Influencer` - Devise authentication, has_many users
- `Pyg` (Profit & Loss) - belongs_to user
- `Balance` - belongs_to user
- `Objective` - belongs_to user
- `Recommendation` - Static content
- `UserAction` - Tracks completed actions (belongs_to user)

### **Key Methods:**

**User model:**
```ruby
# Financial health
def financial_health_level # Returns string: "Situación Crítica", etc.
def financial_health_level_number # Returns 1-6

# Recommendations
def financial_recommendations # Returns array of rec_keys
def recommendations_with_links # Returns array of { product, affiliate_link }
def get_affiliate_link(product_type) # Returns URL or nil

# Action plan
def action_plan # Returns unified array of recommendations + objectives
def current_task # Returns first uncompleted action
def complete_recommendation!(rec_key)
def uncomplete_recommendation!(rec_key)

# Financial calculations
def monthly_cash_flow
def emergency_fund_target
def has_emergency_fund?
def net_worth
def investment_income_monthly
def has_financial_freedom?
```

**Objective model:**
```ruby
def valid_for_display?
def months_to_target
def years_to_target
def is_retirement_objective?
def investment_recommendation # Returns: ac_diposit, ac_curt, ac_llarg, ac_jubil
def annual_return_rate # Returns: 0.015, 0.03, 0.08
def monthly_savings_needed # Compound interest calculation
def savings_capacity_analysis # Returns { sufficient, monthly_needed, available_cash_flow, surplus/deficit }
def objective_icon # Returns Bootstrap icon class based on title keywords
```

### **Financial Calculations:**

**Investment income:**
```ruby
# Cash + Savings: 0.5% annual
# Investments + Pensions: 4% annual
# Real Estate: 1.5% annual
```

**Emergency fund target:** 4 months of expenses

**Debt-free criteria:** debt-to-assets ≤15% OR total debt ≤2x annual income

**Compound interest formula:**
```ruby
# monthly_savings_needed calculation:
monthly_rate = annual_return_rate / 12
periods = months_to_target
target_amount / (((1 + monthly_rate) ** periods - 1) / monthly_rate)
```

---

## Design System

### **Colors:**
```
Green (#1EDD88)  → Completed, positive, objectives, main CTA
Blue (#0D6EFD)   → Current level, information, recommendations
Yellow (#FFC65A) → Warning
Red (#FD1015)    → Negative, delete
Gray (#6c757d)   → Disabled, secondary
```

### **Icons:**
All Bootstrap Icons (bi-* classes):
- `bi-bank` - Better bank account
- `bi-shield-check` - Emergency fund
- `bi-credit-card-2-back` - Debt optimization
- `bi-house-door` - Mortgage optimization
- `bi-graph-up-arrow` - Portfolio optimization
- `bi-calculator` - Tax advisory
- `bi-lightbulb` - Saving advice
- `bi-bar-chart` - Medium-term investment
- `bi-graph-up` - Long-term investment
- `bi-piggy-bank-fill` - Retirement
- `bi-plus-circle` - Create objective

Plus dynamic objective icons based on keywords.

### **Mobile-First:**
- All layouts responsive
- Forms optimized for mobile
- Touch-friendly buttons (min 44px)
- Readable font sizes (min 16px for inputs)

---

## Summary

**Current Status:** App is ~80% complete. Core functionality working.

**To launch Beta:** Only need Task 1 (Recommendation Pages) + Task 2 (Plan Main Content Design)

**After Beta:** Implement Phase 5 improvements based on user feedback

**Timeline:** Beta ready in 1-2 weeks if focused on Task 1 & 2
