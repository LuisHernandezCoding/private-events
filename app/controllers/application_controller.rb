class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Check if the user has a profile before every action except the profile creation page
  before_action :check_for_profile, if: :user_signed_in?

  protected

  # Configure permitted parameters for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
    devise_parameter_sanitizer.permit(:account_update, keys: [:otp_attempt])
  end

  # Check if the user has a profile
  def check_for_profile
    return if current_user.profile.present?

    return if (controller_name == 'profiles' && action_name == 'new') ||
              (controller_name == 'profiles' && action_name == 'create') ||
              (controller_name == 'sessions' && action_name == 'destroy')

    # If the user doesn't have a profile, redirect to the profile creation page
    redirect_to new_profile_path, notice: 'Please create a profile'
  end
end
