class OrganizersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :check_for_organizer, only: %i[new create]

  def index
    @organizers = Organizer.all
  end

  def show
    @profile = Profile.find_by(username: params[:username])
    redirect_to profile_path(@profile.username)
  end

  def new
    @organizer = Organizer.new
  end

  def create
    @organizer = Organizer.new(organizer_params)
    @organizer.profile = current_user.profile
    if @organizer.save
      redirect_to new_event_path
    else
      render :new
    end
  end

  def edit
    profile = Profile.find_by(username: params[:username])
    @organizer = Organizer.find_by(profile:)
  end

  def update
    profile = Profile.find_by(username: current_user.profile.username)
    @organizer = Organizer.find_by(profile:)
    @organizer.update(organizer_params)
    redirect_to show_organizer_path(@organizer.profile.username)
  end

  def destroy
    @organizer = Organizer.find_by(username: params[:username])
    @organizer.destroy
    redirect_to organizers_path
  end

  private

  def organizer_params
    params.require(:organizer).permit(:experience, :team, :events_quantity_expectation, :events_size_expectation,
                                      :preferences_ticketing, :preferences_data_collection, :preferences_publicity,
                                      :preferences_analytics, :preferences_reputation, :preferences_marketing)
  end

  def check_for_organizer
    redirect_to edit_organizer_path(current_user.profile.username) if current_user.profile.organizer
  end
end
