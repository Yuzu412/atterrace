Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show]
  
  resources :groups, only: [:index, :new, :create, :show, :edit, :update, :destroy] do
    member do
      get :invitation_link
      get 'join/:token', to: 'groups#join', as: 'join_with_token'
      post 'join', to: 'groups#join_group', as: 'join_group'
    end

    resources :blogs do
      resources :likes, only: [:create]
      resources :comments, only: [:create]
    end
    resources :tweets, only: [:show, :new, :create, :edit, :update, :destroy] do
      resources :likes, only: [:create]
      resources :comments, only: [:create]
    end
  end

  root 'hello#index'
  get 'hello/index' => 'hello#index'
  get 'hello/link' => 'hello#link'
end
