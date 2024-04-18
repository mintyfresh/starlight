# frozen_string_literal: true

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get :up, to: 'rails/health#show', as: :rails_health_check

  root to: 'events#index'

  get 'auth/sign_in', to: 'auth#sign_in'
  get 'auth/discord', to: 'auth#discord'

  resources :events, param: :slug, only: %i[index show edit update] do
    member do
      post :publish
      post :check_in, as: :check_in_for
    end

    resource :registration, only: %i[show create destroy]
  end

  namespace :webhooks do
    post 'discord', to: 'discord#callback'
  end
end
