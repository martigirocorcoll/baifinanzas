Rails.application.routes.draw do
  # Recomendaciones ampliadas
  resources :recommendations, only: [:show], param: :slug
  get "dashboard/index"
  # Devise
  devise_for :users

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

  # CRUD de Influencers (admin/privilegiados)
  resources :influencers

  # Recursos financieros del usuario (1:1)
  resource  :pyg,     only: %i[show new create edit update]
  resource  :balance, only: %i[index show new create edit update]

  # Objetivos (1:N)
  resources :objectives
end
