DearFriend::Application.routes.draw do

  get "payments/success_callback"
  get "payments/cancel_callback"

  resources :projects, only: [:show] do
    collection do
      get 'downloaded_messages'
    end
    member do
      post 'take_messages'
      get 'download_messages'
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
