Rails.application.routes.draw do

  # devise_for :users
  resources :places
  resources :events
  get 'import', to: 'events#import', as: :import
  match '/events/get_address_and_loc' => 'events#get_address_and_loc', :via => :post


  root 'pages#home'
  get 'pages/dates'
  get 'pages/user_index'
  get 'pages/sample_user'
  get 'pages/explore'
  get 'pages/dating'
  get 'pages/bundle_9786063511'
  get '/adventures', to: 'pages#adventures'
  get '/join' => redirect('https://app.moonclerk.com/pay/j0cqdx8sij4')
  get '/rec', to: 'pages#rec'
  get '/another', to: 'pages#another'

  # ANALYTICS DASHBOARD
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  match '/dashboard/metrics' => 'dashboard#metrics', :via => :post

  # FRONT WEBHOOK
  match '/front/mirror' => 'front#mirror', :via => :post
end
