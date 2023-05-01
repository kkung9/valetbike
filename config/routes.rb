Rails.application.routes.draw do
  get 'guests/create'
  # home page
  root to: "stations#index"

  # for admin
  resources :stations, only: [:index]

  # stations routes
  get '/station/:identifier', to: 'stations#station_view', as: 'station'
  match '/index', to: "stations#index", via: :get
  get '/search(/:name)', to: "stations#search", as: 'search'
  match '/list', to: "stations#list", via: :get
  match '/map', to: "stations#map", via: :get
  match '/faqs', to: "stations#faqs", via: :get
  match '/meet-the-team', to: "stations#meet_the_team", via: :get
  
  # rentals routes
  get '/rental/:identifier', to: 'rentals#rental', as: 'rental'
  get '/confirm/:station_identifier/:bike_identifier', to: 'rentals#purchase_confirm', as: 'confirm'
  get '/receipt/:id', to: 'rentals#receipt', as: 'receipt'
  get '/current_ride', to: 'rentals#current_ride', as: 'current'
  post '/rental/:station_identifier/:bike_identifier/:duration', to: 'rentals#create', as: 'rent'
  get '/lock/:id', to: 'rentals#lock', as: 'lock'
  patch '/return/:id', to: 'rentals#return', as: 'return'
  get 'rentals/checkout', to: 'rentals#checkout'
  get 'rentals/success/:duration', to: 'rentals#success', as: "success"
  get 'rentals/cancel', to: 'rentals#cancel'
  post 'member_ride', to: "rentals#member_ride", as: "member_ride"
  get '/extend.:id', to: "rentals#extend", as: "extend"
  post 'extend_time.:id', to: "rentals#extend_time", as: "extend_time"
  post "pay", to: "rentals#pay", as: "pay"

  # users routes
  get '/past_purchases/:identifier', to: 'users#profile_purchases', as: 'purchases'
  match '/profile', to: "users#profile", via: :get
  match '/create_account', to: "users#create_account", via: :get
  match '/account_confirmation', to: "users#account_confirmation", via: :get
  post 'users', to: 'users#create', as: 'create'
  match '/user_login', to: "users#user_login", via: :get
  match '/login_verification', to: "users#login_verification", via: :get
  get '/delete_user/:id', to: 'users#delete', as: 'delete_user'
  delete 'hellowearedeleting/:id', to: 'users#destroy', as: 'destroy_user'
  resources :users, only: [:delete]
  get '/subscriptions', to: 'users#subscriptions', as: 'subscriptions'
  get '/subscription_success', to: 'users#sub_scess', as: 'sub_scess'
  post 'subscribe', to: 'users#subscribe', as: 'subscribe'
  post '/unsubscribe', to: 'users#unsubscribe', as: 'unsubscribe'

  # sessions routes
  post 'temps', to: 'sessions#create', as: 'create_session'
  match '/user_logout', to: "sessions#logout", via: :get  
  get 'sessions/create'
  post 'code', to: "sessions#login", as: 'start_login'
  get '/guest_option', to: 'users#guest_or_login', as: 'guest_option'
  post 'start_guest', to: 'guests#create', as: 'start_guest'

  get 'set_theme', to: 'theme#update'
end