Rails.application.routes.draw do
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
    get '2fa/settings', to: 'users_otp#settings', as: 'users_otp_settings'
    patch 'users_otp/enable', to: 'users_otp#enable', as: 'enable_2fa'
    patch 'users_otp/disable', to: 'users_otp#disable', as: 'disable_2fa'
  end

  devise_for :users, controllers: {
    sessions: 'sessions'
  }

  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'test', to: 'pages#test'

  resources :profiles, only: %w[index new create show edit], param: :username
  resources :profiles, only: %w[update]

  get 'profiles/:username/interests/edit', to: 'profile_interests#edit', as: 'edit_profile_interests'
  patch 'profiles/:username/interests/', to: 'profile_interests#update', as: 'update_profile_interests'
  post 'profiles/:username/interests/', to: 'profile_interests#create', as: 'create_profile_interests'
  delete 'profiles/:username/interests/', to: 'profile_interests#destroy', as: 'destroy_profile_interests'
end
