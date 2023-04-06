Rails.application.routes.draw do
  get 'auth/jwt'

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :cages, param: :id do
        member do
          get 'dinosaurs', to: 'cages#dinosaurs'
        end
      end
      post 'login', to: 'sessions#create'
    end
  end
end
