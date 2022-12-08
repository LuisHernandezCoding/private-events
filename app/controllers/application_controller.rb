class ApplicationController < ActionController::Base
  # Define variables for use in the application layout
  # See: https://guides.rubyonrails.org/layouts_and_rendering.html#using-instance-variables
  before_action :set_title

  # Define the title for the application layout
  def set_title
    @title = "My Blog"
  end
end
