Rails.application.routes.draw do
  resources :user, only: %i[edit update]
  devise_for :users, path: '',
                     path_names: { sign_in: 'login', sign_out: 'logout' }
  root to: 'dataset#index'
  resources :dataset, only: %i[index create]
end
