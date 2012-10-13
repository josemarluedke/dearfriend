DearFriend::Application.routes.draw do

  resources :projects, only: [:show]

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :authorizations, only: [:destroy]

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => 'home#index'
end
