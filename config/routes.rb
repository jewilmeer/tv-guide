TvEpisodes::Application.routes.draw do
  match '/login',           :to => 'user_sessions#new'
  match '/logout',          :to => 'user_sessions#destroy'
  match '/signup',          :to => 'user/users#new'

  match "/user/:user_id/programs/t/:user_credentials" => 'user/programs#aired', :as => 'tokened_user_programs'
  match "/programs/:id/t/:user_credentials" => 'programs#show', :as => 'tokened_program'
  match "/programs/:program_id/episodes/:id(/t/:user_credentials)(.:format)" => 'episodes#show', :as => 'episode_download'
  match "/settings(.:format)" => "settings#index", :as => :setting
  match '/sitemap', :to => 'pages#sitemap'
  
  resources :programs do 
    collection do
      post :search
      get :check, :guide, :suggest
    end
    member do
      get :banners
    end
  
    resources :episodes do
      member do
        get :download, :search
        put :mark
      end
    end
  end
  
  resources :images
  resources :episodes do
    member do
      get :search
    end
  end
  resources :pages, :only => [:index, :show]
  resource :user_session, :only => [:new, :create, :destroy]
  
  resources :users, :module => 'user', :path => '/user' do
    resource :settings
    resources :programs do
      get :aired, :on => :collection
    end
    resources :authentications, :program_preferences
  end
  
  # match '/oauth/start',     :to => 'oauths#start'
  # match '/oauth/callback',  :to => 'oauths#callback'
  # match '/oauth',           :to => 'oauths#destroy'
  
  namespace :admin do
    root :to => 'pages#root'
    resources :users, :pages, :configurations, :search_term_types
    resources :images, :authentications, :interactions, :program_preferences
    resources :episodes do
      get :tvdb_update, :on => :member
    end
    resources :programs do
      resources :images
    end

    match '/charts/episodes' => 'charts#episodes'
  end
  
  root :to => "pages#index"
end
