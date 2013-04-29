Awaken::Application.routes.draw do
  resources :videos, only: [:index, :show]
  namespace :admin do
    resources :videos do
      get 'thumbnail/:time', :on => :member, :action => 'thumbnail'
    end
    resources :pages
    root to: 'videos#index'
  end
  post "zencoder-callback" => "zencoder_callback#create", :as => "zencoder_callback"
  root to: 'videos#index'
  get ':id', to: 'pages#show', as: :page

end
