Rails.application.routes.draw do
  # home page
  root to: "stations#index"

  # for admin
  # resources :bikes,    only: [:index]
  resources :stations, only: [:index]
  resources :rentals,  only: [:create]


  # stations routes
  get '/station/:identifier', to: 'stations#station_view', as: 'station'
  match '/index', to: "stations#index", via: :get
  get '/search(/:name)', to: "stations#search", as: 'search'
  match '/list', to: "stations#list", via: :get
  match '/map', to: "stations#map", via: :get
  
  # rentals routes
  get '/rental/:identifier', to: 'rentals#rental', as: 'rental'
  get '/confirm/:station_identifier/:bike_identifier', to: 'rentals#purchase_confirm', as: 'confirm'
  get '/receipt/:id', to: 'rentals#receipt', as: 'receipt'
  get '/current_ride', to: 'rentals#current_ride', as: 'current'
  post '/rental/:station_identifier/:bike_identifier', to: 'rentals#create', as: 'rent'
  get '/lock/:id', to: 'rentals#lock', as: 'lock'
  patch '/update/:id', to: 'rentals#update', as: 'update'

  # users routes
  get '/past_purchases/:identifier', to: 'users#profile_purchases', as: 'purchases'
  match '/profile', to: "users#profile", via: :get
  match '/create_account', to: "users#create_account", via: :get
  match '/account_confirmation', to: "users#account_confirmation", via: :get
  post 'users', to: 'users#create', as: 'create'
  match '/user_login', to: "users#user_login", via: :get
  match '/login_verification', to: "users#login_verification", via: :get

  # sessions routes
  post 'temps', to: 'sessions#create', as: 'create_session'
  match '/user_logout', to: "sessions#logout", via: :get  
  get 'sessions/create'
  post 'code', to: "sessions#login", as: 'start_login'

end