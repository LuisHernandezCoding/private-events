Rails.application.routes.draw do
  devise_scope :user do
    get "users", to: "devise/sessions#new"
    get 'users_otp/settings'
    patch 'users_otp/enable', to: 'users_otp#enable', as: 'enable_2fa'
    patch 'users_otp/disable', to: 'users_otp#disable', as: 'disable_2fa'
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

  # Index page for all users:
  get 'users/profiles', to: 'profiles#index', as: 'profiles'

  # show profile page for a user:
  get 'users/:id/profile', to: 'profiles#show', as: 'user_profile'

  # edit profile page for a user:
  get 'users/:id/profile/edit', to: 'profiles#edit', as: 'edit_profile'

  # update profile page for a user:
  patch 'users/:id/update', to: 'profiles#update', as: 'update_profile'
end
