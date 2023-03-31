Rails.application.routes.draw do
  get 'stations/index'
  root to: "stations#index"

  resources :bikes,    only: [:index]
  resources :stations, only: [:index]

  match '/index', to: "stations#index", via: :get
  match '/search', to: "stations#search", via: :get
  match '/list', to: "stations#list", via: :get
  match '/profile', to: "users#profile", via: :get
  match '/past_purchases', to: "users#profile_purchases", via: :get
  match '/map', to: "stations#map", via: :get
  match '/station', to: "stations#station_view", via: :get
  match '/rental', to: "rentals#rental", via: :get
  match '/receipt', to: "rentals#receipt", via: :get
  match '/purchase_confirmation', to: "rentals#purchase_confirm", via: :get
  match '/current_ride', to: "rentals#current_ride", via: :get
  match '/create_account', to: "users#create_account", via: :get

end