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
  get 'pages/join'
  get 'pages/bundle_7814922644'
  get 'pages/bundle_2019565612'
  get 'pages/bundle_8573165109'
  get 'pages/bundle_5083141630'
  get 'pages/bundle_8603061455'
  get 'pages/bundle_2022108246'
  get 'pages/bundle_5087628562'
end
