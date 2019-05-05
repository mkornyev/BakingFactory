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

  # Special route for cart functions 
  get "/cart", to: "cart_items#show", as: "cart"
  post "/add_item", to: "cart_items#add_item", as: "add_item"
  post "/remove_item", to: "cart_items#remove_item", as: "remove_item"
  post "/clear", to: "cart_items#clear", as: "clear"
  post "/place_order", to: "cart_items#place_order", as: "place_order"

  # get 'customers/new', to: 'customers#new', as: :signup
  # get 'users/new', to: 'users#new', as: :signup
  # get 'user/edit', to: 'users#edit', as: :edit_current_user
  
  # get 'sessions', to: 'sessions#new', as: :login
  # get 'sessions', to: 'sessions#destroy', as: :logout
  
  # Set the root url
  root :to => 'home#home'
  
end
