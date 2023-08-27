Rails.application.routes.draw do
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root "home#index"

  resources :tweets, only: [:show, :create] do
    resources :likes, only: [:create, :destroy]
    resources :bookmarks, only: [:create, :destroy]
    resources :retweets, only: [:create, :destroy]
    resources :reply_tweets, only: [:create]
  end

  get :dashboard, to: "dashboard#index"
  get :profile, to: "profile#show"
  put :profile, to: "profile#update"

  resources :usernames, only: [:new, :update]

  resources :users, only: [:show] do
    resources :followings, only: [:create, :destroy]
  end
end
