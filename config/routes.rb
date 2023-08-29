# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :wines, only: [:index] do
        post 'ratings', on: :member, to: 'wines#create_rating'
        get 'ratings', on: :member, to: 'wines#ratings'
        put 'ratings/:rating_id', on: :member, to: 'wines#update_rating', as: :update_rating
        delete 'ratings/:rating_id', on: :member, to: 'wines#destroy_rating', as: :delete_rating
      end
    end
  end
end
