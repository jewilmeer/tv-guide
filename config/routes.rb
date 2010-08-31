TvEpisodes::Application.routes.draw do
  resources :programs do 
    post :suggest, :on => :collection
    get :search, :on => :collection
    resources :seasons
    resources :episodes do
      member do
        get :download
        put :mark
      end
    end
  end
  
  resources :episodes do
    member do
      get :download
      get :search
      put :mark
    end
  end
  
  resources :pages, :only => [:index, :show]
  resource :user_session, :only => [:new, :create, :destroy]

  resources :users, :module => 'user', :path => '/user' do
    resource :settings
    resources :programs
  end
  
  # match '/oauth/start',     :to => 'oauths#start'
  # match '/oauth/callback',  :to => 'oauths#callback'
  # match '/oauth',           :to => 'oauths#destroy'
  match '/login',           :to => 'user_sessions#new'
  match '/logout',          :to => 'user_sessions#destroy'
  match '/signup',          :to => 'user/users#new'
  
  namespace :admin do
    root :to => 'pages#root'
    resources :programs, :users, :pages, :configurations
    resources :episodes, :only => :show do
      get :download, :on => :member
    end
  end
  
  # namespace :auth do
  #   match 'facebook/callback', :to => 'facebook#callback'
  #   match 'facebook/remove', :to => 'facebook#remove'
  # end
  
  match "/settings(.:format)" => "settings#index", :as => :setting
  root :to => "pages#index"
end
