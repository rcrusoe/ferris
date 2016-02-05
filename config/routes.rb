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
end
