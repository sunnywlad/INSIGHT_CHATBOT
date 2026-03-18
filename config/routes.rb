Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  root to: "pages#home"

  resources :products, only: [:index, :new, :create, :show] do
    resources :chats, only: [:new, :create]
  end

  resources :chats, only: [:show] do
    resources :messages, only: [:create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
