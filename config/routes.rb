DearFriend::Application.routes.draw do

  resources :projects, only: [:show] do
    member do
      post 'download_messages'
    end
  end

  resources :messages, only: [:new, :create, :update] do
    member do
      get 'select_project'
      get 'confirm_payment'
      post 'pay'
    end
  end

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  resources :authorizations, only: [:create, :destroy]

  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks",
                                       registrations: "users/registrations"}

  root :to => 'home#index'
end
