Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v0 do
      resources :vendors, only: [:show, :create, :update, :destroy]
      resources :market_vendors, only: [:create]
      resource :market_vendors, only: [:destroy]

      get "/markets/search", to: "markets#search"
      get "/markets/:id/nearest_atms", to: "markets#nearest_atms"

      resources :markets, only: [:index, :show] do
        resources :vendors, only: [:index]
      end
    end
  end
end
