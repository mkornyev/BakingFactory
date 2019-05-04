Rails.application.routes.draw do
  
  # Routes for main resources
  resources :addresses
  resources :customers
  resources :orders
  resources :items
  resources :users

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'contact' => 'home#contact', as: :contact
  get 'privacy' => 'home#privacy', as: :privacy

  # Authentication routes
  controller :sessions do
    get 'login' => :new
    post 'login' => :create 
    delete 'logout' => :destroy
  end
  get "sessions/create" 
  get "sessions/destroy"

  # Special route for changing price 
  get "/toggle", to: "customers#toggle_activity", as: "toggle"

  # get 'customers/new', to: 'customers#new', as: :signup
  # get 'users/new', to: 'users#new', as: :signup
  # get 'user/edit', to: 'users#edit', as: :edit_current_user
  
  # get 'sessions', to: 'sessions#new', as: :login
  # get 'sessions', to: 'sessions#destroy', as: :logout
  
  # Set the root url
  root :to => 'home#home'
  
end
