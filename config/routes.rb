Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :movies, only: %i[index show] do
    resources :list_items, only: %i[create]
    resources :reviews, only: %i[create]
  end

  resources :reviews, only: %i[edit update destroy]
  resources :list_items, only: %i[destroy]

  resources :tvs, only: %i[index show] do
    resources :list_items, only: %i[create]
    resources :reviews, only: %i[create]
  end

  resources :lists
  get '/dashboard', to: "dashboard#index"
end
