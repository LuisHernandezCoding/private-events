class ProfileInterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_profile!

  def create
    profile = Profile.find_by(username: params[:username])
    interest = profile.profile_interests.new(interest_id: params[:interest_id])
    if interest.save 
      redirect_back(fallback_location: root_path)
    else
      redirect_to profile_path(profile.username), notice: 'Interest not added'
    end
  end

  def destroy
    Profile.find_by(username: params[:username]).profile_interests.find_by(interest_id: params[:interest_id]).delete
    redirect_back(fallback_location: root_path)
  end

  def edit
    @profile = Profile.find_by(username: params[:username])
    @interests = Interest.all
    @categories = Category.all
    @profile_interests = @profile.profile_interests
  end

  def update
    @profile = Profile.find_by(username: params[:username])
    @profile.profile_state = 'interested' if @profile.profile_state == 'created'
    @profile.save
    @profile.profile_interests.destroy_all

    params[:profile_interests].each do |interest|
      ProfileInterest.new(interest_id: interest[0], profile_id: @profile.id).save
    end

    redirect_to profile_path(@profile.username)
  end

  private

  def check_profile!
    return if current_user.profile.username == params[:username].to_s

    redirect_to root_path, alert: 'You are not authorized to do that'
  end
end
