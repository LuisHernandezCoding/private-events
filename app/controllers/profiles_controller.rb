class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @profiles = Profile.all
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    # check if the user is the owner of the profile
    if current_user.id == params[:id].to_i
      @user = User.find(params[:id])
      @profile = Profile.new
    else
      redirect_to root_path, notice: 'You are not allowed to edit this profile'
    end
  end

  def update
    @user = User.find(params[:id])
    @profile = Profile.new(profile_params)
    @profile.user_id = @user.id
    if @profile.save
      redirect_to user_profile_path(@user), notice: 'Profile updated successfully'
    else
      render 'edit', notice: 'Profile not updated', locals: { user: @user, profile: @profile }
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
