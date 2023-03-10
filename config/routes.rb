Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api, defaults: {format: :json} do
    resources :activity_types, only: [:create, :update, :delete, :show, :index, :destroy]
    resources :careers, only: [:create, :update, :delete, :show, :index, :destroy]
  end
end
