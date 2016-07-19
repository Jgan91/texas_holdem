Rails.application.routes.draw do
  root "welcome#index"

  get "/rooms", to: "rooms#show"

  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, only: [:create, :show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server => "/cable"
end
