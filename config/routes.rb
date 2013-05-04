Awaken::Application.routes.draw do
  resources :videos, only: [:index, :show]
  namespace :admin do
    resources :videos do
      member do
        get 'thumbnail/:time', :action => 'thumbnail'
        post 'screenshot'
      end
    end
    resources :pages
    root to: 'videos#index'
  end
  post "zencoder-callback" => "zencoder_callback#create", :as => "zencoder_callback"
  root to: 'videos#index'
  get ':id', to: 'pages#show', as: :page

end
