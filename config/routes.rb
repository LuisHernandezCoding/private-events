Rails.application.routes.draw do
  devise_scope :user do
    get 'users', to: 'devise/sessions#new'
    get '2fa/settings', to: 'users_otp#settings', as: 'users_otp_settings'
    get 'profiles/:username/2fa/ask', to: 'users_otp#ask', as: 'users_otp_ask'
    patch 'users_otp/enable', to: 'users_otp#enable', as: 'enable_2fa'
    patch 'users_otp/disable', to: 'users_otp#disable', as: 'disable_2fa'
  end

  devise_for :users, controllers: {
    sessions: 'sessions'
  }

  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  post 'contact', to: 'pages#contact_create'
  get 'contact_success', to: 'pages#contact_success'
  get 'TOS', to: 'pages#tos', as: 'tos'
  get 'privacy', to: 'pages#privacy'

  resources :profiles, only: %w[index new create show edit], param: :username
  resources :profiles, only: %w[update]

  patch 'profiles/:username/next_step', to: 'profiles#next_step', as: 'next_step'
  patch 'profiles/:username/privacity', to: 'profiles#privacity', as: 'privacity'

  get 'profiles/:username/interests/edit', to: 'profile_interests#edit', as: 'edit_profile_interests'
  patch 'profiles/:username/interests/', to: 'profile_interests#update', as: 'update_profile_interests'
  post 'profiles/:username/interests/', to: 'profile_interests#create', as: 'create_profile_interests'
  delete 'profiles/:username/interests/', to: 'profile_interests#destroy', as: 'destroy_profile_interests'

  get 'profiles/:username/ubications/country', to: 'ubications#country', as: 'country'
  patch 'profiles/:username/ubications/country', to: 'ubications#update_country', as: 'update_country'
  get 'profiles/:username/ubications/state', to: 'ubications#state', as: 'state'
  patch 'profiles/:username/ubications/state', to: 'ubications#update_state', as: 'update_state'
  get 'profiles/:username/ubications/city', to: 'ubications#city', as: 'city'
  patch 'profiles/:username/ubications/city', to: 'ubications#update_city', as: 'update_city'
end
