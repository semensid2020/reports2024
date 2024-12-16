Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'

  # Task 1
  resources :orders, only: :index
  get 'last_year', to: 'orders#within_last_year', as: :last_year_orders
  get '/api/last_year_by_months', to: 'api/orders#last_year_by_months', as: :last_year_by_months

  resources :preservations, only: %i[index show new create]
  resources :reports, only: %i[index]
  get '/get_report', to: 'reports#get_report', as: :get_report
end
