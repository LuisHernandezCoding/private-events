class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_for_profile, if: :user_signed_in?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
    devise_parameter_sanitizer.permit(:account_update, keys: [:otp_attempt])
  end

  def check_for_profile
    return if current_user.profile.present? || check_for_page

    redirect_to new_profile_path, notice: 'Please create a profile'
  end

  def check_for_page
    return true if (controller_name == 'profiles' && action_name == 'new') ||
                   (controller_name == 'profiles' && action_name == 'create') ||
                   (controller_name == 'sessions' && action_name == 'destroy')
  end

  def check_profile!
    return if current_user.profile.username == params[:username].to_s

    redirect_to root_path, alert: 'You are not authorized to do that'
  end

  def check_event!
    return if current_user.profile.organizer == Event.find(params[:id]).organizer

    redirect_to root_path, alert: 'You are not authorized to do that'
  end
end
