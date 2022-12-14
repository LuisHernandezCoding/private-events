class ProfileInterestsController < ApplicationController
  def create
    Profile.find_by(username: params[:username]).profile_interests.new(interest_id: params[:interest_id]).save
    redirect_back(fallback_location: root_path)
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
    @profile.profile_state = 2 if @profile.profile_state <= 1
    @profile.profile_interests.destroy_all

    params[:profile_interests].each do |interest|
      ProfileInterest.new(interest_id: interest[0], profile_id: @profile.id).save
    end

    redirect_to profile_path(@profile.username)
  end
end
