require 'sidekiq/web'

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    resources :users, only: [:index, :show, :create]
    resource :session, only: [:create, :destroy]
  end
end
