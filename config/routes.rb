Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  root to: "pages#home"

  resources :chats, only: [:index, :new, :create, :show] do
    resources :messages, only: [:new, :create]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
