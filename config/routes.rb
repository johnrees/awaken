Awaken::Application.routes.draw do
  resources :videos, only: [:index, :show]
  namespace :admin do
    resources :videos
    root to: 'videos#index'
  end
  root to: 'videos#index'
end
