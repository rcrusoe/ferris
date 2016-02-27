Rails.application.routes.draw do

  resources :places
  resources :users
  resources :events

  root 'pages#home'
  get 'pages/home'
  get 'pages/user_index'
  get 'pages/sample_user'
  get 'pages/explore'
  get 'pages/dating'
  get 'pages/bundle_9786063511'
  get '/adventures', to: 'pages#adventures'
  get '/dashboard', to: 'pages#dashboard'
  get '/dates', to: 'pages#dates'
end
