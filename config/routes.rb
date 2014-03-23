OmotoFriends::Application.routes.draw do
  root 'home#index'

  resources :items do
     collection do
       post 'upload'
     end
  end

  devise_for :users
  resources :users
end
