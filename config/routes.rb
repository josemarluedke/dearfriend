DearFriend::Application.routes.draw do

  resources :projects, only: [:show]

  resources :messages, only: [:new, :create, :update] do
    member do
      get 'select_project'
      get 'confirm_payment'
    end
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :authorizations, only: [:create, :destroy]

  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks",
                                       registrations: "users/registrations"}

  root :to => 'home#index'
end
