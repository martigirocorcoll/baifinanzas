Rails.application.routes.draw do
  # Devise
  devise_for :users

  # Página pública
  root to: "pages#home"

  # Health check y PWA
  get  "up",             to: "rails/health#show",       as: :rails_health_check
  get  "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get  "manifest",       to: "rails/pwa#manifest",        as: :pwa_manifest

  # CRUD de Influencers (admin/privilegiados)
  resources :influencers

  # Recursos financieros del usuario (1:1)
  resource  :pyg,     only: %i[show new create edit update]
  resource  :balance, only: %i[show new create edit update]

  # Objetivos (1:N)
  resources :objectives
end
