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

  resources :usernames, only: [:new, :update]
end
