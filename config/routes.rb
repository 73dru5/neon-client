Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v2 do
      # resources :users, only: [ :show, :update ]
      get "/users/me", to: "users#me"
      get "/users/organizations", to: "users#organizations"
    end
  end
  root "pages#home"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
end
