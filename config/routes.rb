Awaken::Application.routes.draw do

  resources :videos, only: [:index, :show]

  namespace :admin do
    root to: 'videos#index'
    resources :videos, except: [:show] do
      member do
        # get 'thumbnail/:time', :action => 'thumbnail'
        post 'screenshot'
      end
      collection do
        post :sort
      end
    end
    resources :pages
    mount RedactorRails::Engine => '/redactor_rails'

  end

  post "zencoder-callback" => "zencoder_callback#create", :as => "zencoder_callback"
  get ':id', to: 'pages#show', as: :page

  root to: 'videos#index'

end
