Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'home#index'

  # Task 1
  resources :orders, only: :index
  get 'last_year', to: 'orders#within_last_year', as: :last_year_orders
  get '/api/last_year_by_months', to: 'api/orders#last_year_by_months', as: :last_year_by_months

end
