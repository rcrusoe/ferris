Rails.application.routes.draw do

  devise_for :users
  resources :places
  resources :users
  resources :events

  root 'pages#dates'
  get 'pages/home'
  get 'pages/user_index'
  get 'pages/sample_user'
  get 'pages/explore'
  get 'pages/dating'
  get 'pages/bundle_9786063511'
  get '/adventures', to: 'pages#adventures'
  get '/dashboard', to: 'pages#dashboard'
  get '/join' => redirect("https://app.moonclerk.com/pay/j0cqdx8sij4")
end
