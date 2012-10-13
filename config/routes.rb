DearFriend::Application.routes.draw do

  resources :authorizations, only: [:destroy]

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'home#index'
end
