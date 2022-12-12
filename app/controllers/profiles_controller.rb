class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @profiles = Profile.all
  end

  def show
    @profile = Profile.find_by(username: params[:username])
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    @profile.user = current_user

    if @profile.save
      redirect_to profile_path(@profile.username), notice: 'Profile Created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    if current_user.profile.username == params[:username].to_s
      @profile = Profile.find_by(username: params[:username])
    else
      redirect_to root_path, notice: 'You are not allowed to edit this profile'
    end
  end

  def update
    @profile = Profile.find(params[:id])

    if @profile.update(profile_params)
      redirect_to profile_path(@profile.username), notice: 'Profile updated successfully'
    else
      render :edit, notice: 'Profile not updated', locals: { user: @profile.user, profile: @profile },
                    status: :unprocessable_entity
    end
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

  private 

  def profile_params
    params.require(:profile).permit(:username, :first_name, :last_name, :gender, :title, :birthday, :country, :street,
                                    :house_number, :city, :state, :phone, :terms)
  end
end
