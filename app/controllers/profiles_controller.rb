class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @profiles = Profile.all
  end

  def show
    @profile = Profile.find_by(username: params[:username])
  end

  def new
    return redirect_to root_path, alert: 'You already have a profile' if current_user.profile.present?

    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user

    if @profile.save
      @profile.profile_state = 'created'
      @profile.save
      redirect_to edit_profile_interests_path(@profile.username), notice: 'Profile created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if current_user.profile.username == params[:username].to_s
      @profile = Profile.find_by(username: params[:username])
    else
      redirect_to root_path, alert: 'You are not allowed to edit this profile'
    end
  end

  def update
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      redirect_to profile_path(@profile.username), notice: 'Profile updated successfully'
    else
      render :edit, alert: 'Profile not updated', locals: { user: @profile.user, profile: @profile },
                    status: :unprocessable_entity
    end
  end

  def ubication
    @profile = Profile.find(params[:id])
  end

  def self.titles
    {
      'None' => 'None',
      'Mr' => 'Mr',
      'Mrs' => 'Mrs',
      'Ms' => 'Ms',
      'Miss' => 'Miss',
      'Dr' => 'Dr',
      'Prof' => 'Prof'
    }
  end

  def next_step
    @profile = Profile.find_by(username: params[:username])
    @profile.profile_state = 'completed' if @profile.profile_state == 'located'
    @profile.profile_state = 'located' if @profile.profile_state == 'interested'
    @profile.profile_state = 'interested' if @profile.profile_state == 'created'
    @profile.save
    redirect_back(fallback_location: root_path)
  end

  def privacity
    @profile = Profile.find_by(username: params[:username])
    @profile.public_profile = !@profile.public_profile
    @profile.save
    redirect_back(fallback_location: root_path)
  end

  private

  def profile_params
    params.require(:profile).permit(:username, :first_name, :last_name, :gender, :title, :birthday, :country, :street,
                                    :house_number, :city, :state, :phone, :terms)
  end
end
