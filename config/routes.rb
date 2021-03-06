Rails.application.routes.draw do

  resources :categories
  # devise_for :users
  resources :places
  resources :events
  get 'import/events', to: 'events#import', as: :import_events
  get 'import/places', to: 'places#import', as: :import_places
  match '/events/get_address_and_loc' => 'events#get_address_and_loc', :via => :post


  root 'pages#home'
  get 'pages/dates'
  get 'pages/user_index'
  get 'pages/sample_user'
  get 'pages/explore'
  get 'pages/dating'
  get 'pages/bundle_9786063511'
  get '/adventures', to: 'pages#adventures'
  get '/rec', to: 'pages#rec'
  get '/another', to: 'pages#another'
  get '/join', to: 'pages#join'
  get '/test', to: 'pages#test'
  get '/postcard', to: 'pages#postcard'

  # ANALYTICS DASHBOARD
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  match '/dashboard/metrics' => 'dashboard#metrics', :via => :post

  # FRONT WEBHOOK
  match '/front/mirror' => 'front#mirror', :via => :post
  match '/front/bot' => 'front#bot', :via => :post
end
