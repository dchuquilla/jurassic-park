Rails.application.routes.draw do
  get 'auth/jwt'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
    end
  end
end
