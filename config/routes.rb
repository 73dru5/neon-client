Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v2 do
      # resources :users, only: [ :show, :update ]
      get "/users/me", to: "users#me"
      get "/users/organizations", to: "users#organizations"
      post "/api_keys", to: "keys#create"
    end
  end

  get "/login", to: "sessions#new"
  get "/auth/keycloak/callback", to: "sessions#create"
  get "/auth/failure", to: redirect("/")
  delete "/logout", to: "sessions#destroy"

  root "home#index"
end
