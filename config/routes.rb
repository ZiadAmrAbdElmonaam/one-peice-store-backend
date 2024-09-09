Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :categories, only: %i[index show create update destroy] do
        resources :products, only: %i[index show create update destroy]
      end
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
end
