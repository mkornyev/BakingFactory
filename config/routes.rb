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

  # Special route for cart functions 
  get "/cart", to: "cart_items#show", as: "cart"
  post "/add_item", to: "cart_items#add_item", as: "add_item"
  post "/remove_item", to: "cart_items#remove_item", as: "remove_item"
  post "/clear", to: "cart_items#clear", as: "clear"
  post "/place_order", to: "cart_items#place_order", as: "place_order"
  post "/orders/new", to: 'orders#new', as: "place_new_order"

  # Shipping list
  get "/shipping", to: "orders#shipping", as: "shipping"
  post "/add_shipping", to: "orders#add_shipping", as: "add_shipping"
  post "/remove_shipping", to: "orders#remove_shipping", as: "remove_shipping"
  post "/ship_items", to: "orders#ship_items", as: "ship_items"

  # Baking List
  get "/baking", to: "orders#baking", as: "baking"

  # Item toggle
  post "/toggle", to: "items#toggle", as: "toggle"

  # Admin Dash
  get "/sales_dash", to: "home#sales_dash", as: "sales_dash"
  post "/sales_dash", to: "home#sales_dash", as: "post_sales_dash"
  get "/customer_dash", to: "home#customer_dash", as: "customer_dash"
  get "/item_dash", to: "home#item_dash", as: "item_dash"

  # get 'customers/new', to: 'customers#new', as: :signup
  # get 'users/new', to: 'users#new', as: :signup
  # get 'user/edit', to: 'users#edit', as: :edit_current_user
  
  # get 'sessions', to: 'sessions#new', as: :login
  get 'sessions', to: 'sessions#destroy', as: 'logout_user'
  
  # Set the root url
  root :to => 'home#home'
  
end
