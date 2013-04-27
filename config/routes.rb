Awaken::Application.routes.draw do
  resources :videos, only: [:index, :show]
  namespace :admin do
    resources :videos
    resources :pages
    root to: 'videos#index'
  end
  post "zencoder-callback" => "zencoder_callback#create", :as => "zencoder_callback"
  root to: 'videos#index'
  get ':id', to: 'pages#show', as: :page

end
