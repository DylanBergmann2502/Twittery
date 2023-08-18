Rails.application.routes.draw do
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root "home#index"

  resources :tweets, only: [:create]
  get :dashboard, to: "dashboard#index"
end
