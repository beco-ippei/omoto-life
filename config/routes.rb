OmotoFriends::Application.routes.draw do
  root 'home#index'

  resources :items do
    collection do
      post 'upload'
    end
    resources :comments
  end

  resources :users, except: [:new, :create]

  resources :user_sessions
  get 'login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
end
