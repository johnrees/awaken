Awaken::Application.routes.draw do
  mount RedactorRails::Engine => '/redactor_rails'

  resources :videos, only: [:index, :show]
  namespace :admin do
    resources :videos do
      member do
        get 'thumbnail/:time', :action => 'thumbnail'
        post 'screenshot'
      end
      collection { post :sort }
    end
    resources :pages
    root to: 'videos#index'
  end
  post "zencoder-callback" => "zencoder_callback#create", :as => "zencoder_callback"
  root to: 'videos#index'
  get ':id', to: 'pages#show', as: :page

end
