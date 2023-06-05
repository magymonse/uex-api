Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api, defaults: {format: :json} do
    resources :activity_types, only: [:create, :update, :show, :index, :destroy]
    resources :users, only: [:create, :show, :index, :destroy]
    resources :careers, only: [:create, :update, :show, :index, :destroy]
    resources :organizations, only: [:create, :update, :show, :index, :destroy]
    resources :students, only: [:create, :update, :show, :index, :destroy]
    resources :professors, only: [:create, :update, :show, :index, :destroy]
    resources :activities, only: [:create, :update, :show, :index, :destroy]
    resources :activity_weeks, only: [:create, :update, :show, :index, :destroy]
    resources :activity_week_participants, only: [:create, :update, :show, :index, :destroy]
  end

  post "refresh", controller: :refresh, action: :create
  post "signin", controller: :signin, action: :create
  delete "signin", controller: :signin, action: :destroy
end
