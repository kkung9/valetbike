Rails.application.routes.draw do
  get 'user/profile'
  root to: "stations#index"

  resources :bikes,    only: [:index]
  resources :stations, only: [:index]

  match '/index', to: "stations#index", via: :get
  match '/search', to: "stations#search", via: :get
  match '/list', to: "stations#list", via: :get
  match '/profile', to: "user#profile", via: :get
  match '/map', to: "stations#map", via: :get
  match '/station', to: "stations#station_view", via: :get
  
end