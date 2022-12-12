Rails.application.routes.draw do
  devise_scope :user do
    get "users", to: "devise/sessions#new"
    get '2fa/settings', to: 'users_otp#settings', as: 'users_otp_settings'
    patch 'users_otp/enable', to: 'users_otp#enable', as: 'enable_2fa'
    patch 'users_otp/disable', to: 'users_otp#disable', as: 'disable_2fa'
  end

  devise_for :users, controllers: {
    sessions: "sessions"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'test', to: 'pages#test'

  # # Index page for all users:
  # get 'profiles', to: 'profiles#index', as: 'profiles'

  # # new profile page for a user:
  # get 'profiles/new', to: 'profiles#new', as: 'new_profile'

  # # create profile page for a user
  # post 'profiles', to: 'profiles#create', as: 'create_profile'

  # # show profile page for a user:
  # get 'profiles/:username', to: 'profiles#show', as: 'user_profile'

  # # edit profile page for a user:
  # get 'profiles/:username/edit', to: 'profiles#edit', as: 'edit_profile'

  # # update profile page for a user:
  # patch 'profiles/:username/update', to: 'profiles#update', as: 'update_profile'
  resources :profiles, only: %w[index new create show edit], param: :username
  resources :profiles, only: %w[update]
end
