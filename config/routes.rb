Rails.application.routes.draw do
  root 'books#index'
  
  resources :books do
    resources :loans, only: [:new, :create]
  end
  
  resources :loans, only: [:index, :show, :update] do
    member do
      patch :return_book
    end
  end
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
end