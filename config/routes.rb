Rails.application.routes.draw do
  # Recomendaciones ampliadas
  resources :recommendations, only: [:show], param: :slug

  # Dashboard
  get "dashboard/index"
  post "dashboard/complete_action", to: "dashboard#complete_action", as: :complete_action
  post "dashboard/uncomplete_action", to: "dashboard#uncomplete_action", as: :uncomplete_action

  # Onboarding flow
  get "onboarding/welcome", to: "onboarding#welcome", as: :onboarding_welcome
  get "onboarding/processing", to: "onboarding#processing", as: :onboarding_processing

  # Devise for Users (with custom registrations controller)
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  # Devise for Influencers (solo login, no registro público)
  devise_for :influencers, path: 'influencers', skip: [:registrations]

  # Página pública
  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end
  unauthenticated do
    root to: "pages#home", as: :unauthenticated_root
  end

  # Health check y PWA
  get  "up",             to: "rails/health#show",       as: :rails_health_check
  get  "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get  "manifest",       to: "rails/pwa#manifest",        as: :pwa_manifest

  # CRUD de Influencers (show = dashboard cuando está autenticado)
  resources :influencers do
    member do
      post :toggle_default
    end
  end

  # Recursos financieros del usuario (1:1)
  resource  :pyg,     only: %i[show new create edit update]
  resource  :balance, only: %i[index show new create edit update]

  # Objetivos (1:N)
  resources :objectives
end
