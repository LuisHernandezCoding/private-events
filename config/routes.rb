Rails.application.routes.draw do
  resources :profiles, only: %w[index new create show edit], param: :username
  resources :profiles, only: %w[update]

  resources :events, param: :short_name
  get 'events/:short_name/step', to: 'events#step', as: 'step_event'
  patch 'events/:short_name/reset', to: 'events#reset', as: 'reset_event'
  patch 'events/:short_name/location/restart', to: 'events#edit_location', as: 'restart_event_location'
  patch 'events/:short_name/interests/restart', to: 'events#edit_interests', as: 'restart_event_interests'
  patch 'events/:short_name/completed', to: 'events#completed', as: 'completed_event'

  get 'events/:short_name/interests/edit', to: 'event_interests#edit', as: 'edit_event_interests'
  patch 'events/:short_name/interests/', to: 'event_interests#update', as: 'update_event_interests'
  post 'events/:short_name/interests/', to: 'event_interests#create', as: 'create_event_interests'
  delete 'events/:short_name/interests/', to: 'event_interests#destroy', as: 'destroy_event_interests'

  post 'events/:short_name/atendees', to: 'event_atendees#create', as: 'attend_event'
  delete 'events/:short_name/atendees', to: 'event_atendees#destroy', as: 'decline_event'

  resources :organizers, only: %w[index new create]
  resources :organizers, only: %w[edit update destroy], param: :username
  get 'organizers/:username', to: 'organizers#show', as: 'show_organizer'

  get 'cities/:state', to: 'events#obtain_cities'
  get 'states/:country', to: 'events#obtain_states'

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
  delete 'contact/:id', to: 'pages#contact_destroy', as: 'contact_destroy'
  get 'TOS', to: 'pages#tos', as: 'tos'
  get 'privacy', to: 'pages#privacy'

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
