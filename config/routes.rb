Rails.application.routes.draw do
  root to: "stations#index"

  resources :bikes,    only: [:index]
  resources :stations, only: [:index]
end