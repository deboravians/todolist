Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  get "/status", to: "status#index", as: :status

  resources :boards, only: %i[index show create update destroy] do
    resources :lists, only: %i[create update destroy] do
      resources :tasks, only: %i[create update destroy]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "boards#index"
end
