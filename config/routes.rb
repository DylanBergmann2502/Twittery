Rails.application.routes.draw do
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root "home#index"

  resources :tweets, only: [:create] do
    resources :likes, only: [:create, :destroy]
  end

  get :dashboard, to: "dashboard#index"

  resources :usernames, only: [:new, :update]
end
