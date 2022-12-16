class UbicationsController < ApplicationController
  before_action :check_profile!

  def country
    @profile = Profile.find_by(username: params[:username])
    @countries = CS.countries.map { |k, v| [v, k] }
  end

  def update_country
    @profile = Profile.find_by(username: params[:username])
    return next_step(@profile.username) if params[:skip] == 'skip'

    @profile.update(country: params[:profile][:country])
    redirect_to state_path(params[:username])
  end

  def state
    @profile = Profile.find_by(username: params[:username])
    if @profile.country.present?
      @states = (CS.get @profile.country)
      if !@states.empty?
        @states = @states.map { |k, v| [v, k] }
      else
        @states = ['No state']
      end
    else
      redirect_to country_path(params[:username]), alert: 'Please select a country first'
    end
  end

  def update_state
    @profile = Profile.find_by(username: params[:username])
    return next_step(@profile.username) if params[:skip] == 'skip'

    @profile.update(state: params[:profile][:state])
    redirect_to city_path(params[:username])
  end

  def city
    @profile = Profile.find_by(username: params[:username])
    if @profile.state.present?
      @cities = @profile.state == 'No state' ? ['No city'] : CS.cities(@profile.state, @profile.country)
    else
      redirect_to state_path(params[:username]), alert: 'Please select a state first'
    end
  end

  def update_city
    @profile = Profile.find_by(username: params[:username])
    return next_step(@profile.username) if params[:skip] == 'skip'

    @profile.update(city: params[:profile][:city])
    next_step(@profile.username)
  end

  private

  def next_step(username)
    @profile = Profile.find_by(username:)
    @profile.profile_state = 'located' if @profile.profile_state == 'interested'
    @profile.save
    redirect_to users_otp_ask_path
  end
end
