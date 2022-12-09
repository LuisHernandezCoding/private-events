class ApplicationController < ActionController::Base
  # Define variables for use in the application layout
  # See: https://guides.rubyonrails.org/layouts_and_rendering.html#using-instance-variables
  before_action :set_title
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Define the title for the application layout
  def set_title
    @title = 'My Blog'
  end

  protected

  # Configure permitted parameters for Devise
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end
end
