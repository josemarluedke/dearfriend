DearFriend::Application.routes.draw do
  get "messages/new"

  resources :projects, only: [:show]

  resources :messages

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :authorizations, only: [:create, :destroy]

  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks",
                                       registrations: "users/registrations"}

  root :to => 'home#index'
end
