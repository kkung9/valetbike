Rails.application.routes.draw do
  get 'stations/index'
  root to: "stations#index"

  resources :bikes,    only: [:index]
  resources :stations, only: [:index]
  resources :rentals,  only: [:create]

  get '/station/:id', to: 'stations#station_view', as: 'station'
  get '/rental/:id', to: 'rentals#rental', as: 'rental'
  get '/confirm/:station_id/:bike_id', to: 'rentals#purchase_confirm', as: 'confirm'
  get '/receipt/:id', to: 'rentals#receipt', as: 'receipt'
  get '/current_ride/:id', to: 'rentals#current_ride', as: 'current'
  post '/create/:station_id/:bike_id', to: 'rentals#create', as: 'create'
  get '/lock/:id', to: 'rentals#lock', as: 'lock'
  patch '/update/:id', to: 'rentals#update', as: 'update'

  match '/index', to: "stations#index", via: :get
  match '/search', to: "stations#search", via: :get
  match '/list', to: "stations#list", via: :get
  match '/profile', to: "users#profile", via: :get
  match '/past_purchases', to: "users#profile_purchases", via: :get
  match '/map', to: "stations#map", via: :get
  match '/receipt', to: "rentals#receipt", via: :get
  match '/current_ride', to: "rentals#current_ride", via: :get
  match '/create_account', to: "users#create_account", via: :get


end