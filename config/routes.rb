require 'sidekiq/web'
TvEpisodes::Application.routes.draw do
  devise_for :users

  resources :stations, only: [:index, :show] do
    get :download_list, on: :member, path: 'download_list/:authentication_token'
    resources :programs, only: [:new, :create, :destroy], controller: 'station/programs'
  end

  namespace :admin do
    root :to => 'pages#root'
    resources :users, :interactions, :episodes, :programs
  end

  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    resources :programs, only: :index
  end

  # deprecated
  get "/user/:user_id/programs/t/:authentication_token" => 'user/programs#aired', :as => 'tokened_user_programs'
  get "/settings(.:format)" => "settings#index", :as => :setting
  get '/sitemap', :to => 'pages#sitemap'

  resources :programs do
    collection do
      post :search
      get :check, :suggest, :guide
    end
    get :download_list, on: :member, path: 'download_list/:authentication_token'

    resources :episodes, only: :show
  end

  resources :episodes, only: [:show, :update] do
    member do
      get :search
      get :download, path: 'download(/:authentication_token)'
    end
  end

  resources :users, :module => 'user', :path => '/user' do
    resource :settings
    resources :programs, only: [:index] do
      get :aired, on: :collection
    end
  end

  root :to => "pages#index"
end
