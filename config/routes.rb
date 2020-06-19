Rails.application.routes.draw do
  root to: 'dataset#index'
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout' }
  resources :user, only: %i[edit update]
  resources :dataset, only: %i[index create show destroy]
  resources :filter, only: %i[create]
  get '/dataset/:id/stats', to: 'dataset#stats', as: 'stats'
end
