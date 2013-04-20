require 'sidekiq/web'
TvEpisodes::Application.routes.draw do
  devise_for :users

  authenticate :users do
    namespace :admin do
      root :to => 'pages#root'
      resources :users, :configurations, :search_term_types
      resources :images, :interactions, :program_preferences
      resources :episodes do
        get :tvdb_update, :on => :member
      end
      resources :programs do
        resources :images
      end
    end
  end

  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    resources :programs, only: :index
  end

  match "/user/:user_id/programs/t/:authentication_token" => 'user/programs#aired', :as => 'tokened_user_programs'
  match "/programs/:id/t/:authentication_token" => 'programs#show', :as => 'tokened_program'
  match "/programs/:program_id/episodes/:id(/t/:authentication_token)(.:format)" => 'episodes#download', :as => 'episode_download'
  match "/settings(.:format)" => "settings#index", :as => :setting
  match '/sitemap', :to => 'pages#sitemap'

  resources :programs do
    collection do
      post :search
      get :check, :guide, :suggest
    end

    resources :episodes, only: :show
  end

  resources :images
  resources :episodes, only: [:show, :update] do
    member do
      get 'search/:quality_code', action: :search, as: :search
      get 'download/:quality_code', action: :download, as: :download
    end
  end

  resources :users, :module => 'user', :path => '/user' do
    resource :settings
    resources :program_preferences, only: [:new, :create, :update]
    resources :programs do
      get :aired, :on => :collection
    end
  end

  resources :stations, only: [:index, :show]

  root :to => "pages#index"
end
