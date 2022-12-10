Rails.application.routes.draw do
  patch 'users_otp/enable'
  patch 'users_otp/disable'

  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end

  devise_for :users, controllers: {
    sessions: "sessions"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "pages#home"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get 'test', to: 'pages#test'
end
