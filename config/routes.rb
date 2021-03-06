Awaken::Application.routes.draw do

  resources :videos, only: [:index, :show] do
    member do
      get :processed
    end
    collection do
      get :ios
    end
  end

  namespace :admin do
    root to: 'videos#index'
    resources :videos, except: [:show] do
      member do
        get 'thumbnail/:time', :action => 'thumbnail', :as => 'thumbnail'
        post 'screenshot'
      end
      collection do
        get :edit_order
        get :upload
        put :sort
        post :fileupload
        put :disable
        post :update_homepage
      end
    end
    resources :pages do
      put :sort, on: :collection
    end
  end

  mount RedactorRails::Engine => '/redactor_rails'

  post "zencoder-callback" => "zencoder_callback#create", :as => "zencoder_callback"
  get ':permalink', to: 'pages#show', as: :page

  root to: 'videos#index'

end
