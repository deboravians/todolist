Rails.application.routes.draw do
  devise_for :users

  get "/status", to: "status#index", as: :status

  resources :boards do
    resources :lists do
      resources :tasks
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "boards#index"
end
