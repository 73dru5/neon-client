Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v2 do
      # resources :users, only: [ :show, :update ]
      get "/users/me", to: "users#me"
      get "/users/organizations", to: "users#organizations"
      post "/api_keys", to: "keys#create"
    end
  end

  get "/sign_in", to: "sessions#new"
  get "/sign_out", to: "sessions#destroy"
  get "/auth/keycloak/callback", to: "sessions#create"
  get "/auth/failure", to: redirect("/")
  get "/authentication_success", to: "sessions#success"
  # delete "/logout", to: "sessions#destroy"

  root "home#index"
end
