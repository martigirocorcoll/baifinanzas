Rails.application.routes.draw do
  # Health check y PWA (sin locale)
  get  "up",             to: "rails/health#show",       as: :rails_health_check
  get  "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get  "manifest",       to: "rails/pwa#manifest",        as: :pwa_manifest

  # Native app endpoints (sin locale)
  get "native/config",             to: "native#config",             as: :native_config
  get "native/tabs",               to: "native#tabs",               as: :native_tabs
  get "native/path-configuration", to: "native#path_configuration", as: :native_path_configuration

  # Root sin locale - redirige al locale por defecto
  root to: redirect("/#{I18n.default_locale}", status: 302)

  # Todas las rutas con scope de locale
  scope "/:locale", locale: /es|en/ do
    # ============================================
    # ADMIN PANEL (requires admin? User)
    # ============================================
    namespace :admin do
      root to: "dashboard#index"
      resources :users, only: [:index, :show, :update]
      resources :articles
      resources :app_news, only: [:index, :new, :create, :edit, :update, :destroy]
      resources :influencers do
        member do
          post :toggle_default
        end
      end
    end

    # ============================================
    # INFLUENCER PANEL (requires Influencer auth)
    # ============================================
    get "influencer", to: "influencer_panel#dashboard", as: :influencer_dashboard
    get "influencer/links", to: "influencer_panel#links", as: :influencer_links
    patch "influencer/links", to: "influencer_panel#update_links"
    get "influencer/videos", to: "influencer_panel#videos", as: :influencer_videos
    patch "influencer/videos", to: "influencer_panel#update_videos"

    # ============================================
    # APP NAVIGATION (Tab Bar routes)
    # ============================================
    # Home (Dashboard + Plan + Objectives)
    get "home", to: "home#index", as: :home

    # Discovery (Content feed: videos, articles, news)
    get "discovery", to: "discovery#index", as: :discovery
    get "discovery/articles/:slug", to: "discovery#show_article", as: :discovery_article

    # Calculators (Financial tools)
    get "calculators", to: "calculators#index", as: :calculators
    get "calculators/compound_interest", to: "calculators#compound_interest", as: :calculator_compound_interest
    get "calculators/mortgage", to: "calculators#mortgage", as: :calculator_mortgage
    get "calculators/emergency_fund", to: "calculators#emergency_fund", as: :calculator_emergency_fund
    get "calculators/financial_freedom", to: "calculators#financial_freedom", as: :calculator_financial_freedom
    get "calculators/investment_goal", to: "calculators#investment_goal", as: :calculator_investment_goal
    get "calculators/early_repayment", to: "calculators#early_repayment", as: :calculator_early_repayment
    get "calculators/investment_returns", to: "calculators#investment_returns", as: :calculator_investment_returns

    # Profile
    get "profile", to: "profiles#show", as: :profile
    get "profile/edit", to: "profiles#edit", as: :edit_profile
    patch "profile", to: "profiles#update"
    get "profile/settings", to: "profiles#settings", as: :profile_settings
    patch "profile/settings", to: "profiles#update_settings"

    # ============================================
    # EXISTING ROUTES
    # ============================================
    # Recomendaciones ampliadas
    resources :recommendations, only: [:index, :show], param: :slug

    # API para user actions (marcar recomendaciones completadas)
    namespace :api do
      get  'user_actions/check', to: 'user_actions#check'
      post 'user_actions/complete', to: 'user_actions#complete'
      post 'user_actions/uncomplete', to: 'user_actions#uncomplete'
    end

    # Dashboard (legacy - will redirect to home)
    get "dashboard/index"
    post "dashboard/complete_action", to: "dashboard#complete_action", as: :complete_action
    post "dashboard/uncomplete_action", to: "dashboard#uncomplete_action", as: :uncomplete_action

    # Onboarding flow
    get "onboarding/welcome", to: "onboarding#welcome", as: :onboarding_welcome
    get "onboarding/basic", to: "onboarding#basic", as: :onboarding_basic
    post "onboarding/basic", to: "onboarding#save_basic"
    get "onboarding/processing", to: "onboarding#processing", as: :onboarding_processing
    get "onboarding/complete", to: "onboarding#complete", as: :onboarding_complete

    # Devise for Users (with custom registrations controller)
    devise_for :users, controllers: {
      registrations: 'users/registrations'
    }

    # Influencer auth removed - influencers now login as Users with role 'influencer'

    # Pagina publica
    authenticated :user do
      root to: "home#index", as: :authenticated_root
    end
    unauthenticated do
      root to: "pages#home", as: :unauthenticated_root
    end

    # Cambio de idioma
    get "set_locale/:new_locale", to: "locales#update", as: :set_locale

    # Legal pages (public, no auth required)
    get "privacy", to: "pages#privacy", as: :privacy
    get "terms",   to: "pages#terms",   as: :terms

    # Recursos financieros del usuario (1:1)
    resource  :pyg,     only: %i[show new create edit update]
    resource  :balance, only: %i[index show new create edit update]

    # Objetivos (1:N)
    resources :objectives do
      member do
        patch :update_progress
      end
    end
  end

  # Redirecciones para URLs sin locale
  get '/admin', to: redirect("/#{I18n.default_locale}/admin")
  get '/influencer', to: redirect("/#{I18n.default_locale}/influencer")
  get '/dashboard', to: redirect("/#{I18n.default_locale}/dashboard/index")
  get '/dashboard/index', to: redirect("/#{I18n.default_locale}/dashboard/index")
  get '/objectives', to: redirect("/#{I18n.default_locale}/objectives")
  get '/pyg', to: redirect("/#{I18n.default_locale}/pyg")
  get '/balance', to: redirect("/#{I18n.default_locale}/balance")
  get '/privacy', to: redirect("/#{I18n.default_locale}/privacy")
  get '/terms', to: redirect("/#{I18n.default_locale}/terms")
end
