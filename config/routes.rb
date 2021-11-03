Rails.application.routes.draw do
  root "static_pages#home"
  get "static_pages/home",to: "static_pages#home"
  get "static_pages/help",to: "static_pages#help"
  get "static_pages/about",to: "static_pages#about"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i(create new show)
end
