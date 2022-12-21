class EventInterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_event!

  def create
    event = Event.find(params[:event_id])
    interest = event.event_interests.new(interest_id: params[:interest_id])
    if interest.save 
      redirect_back(fallback_location: root_path)
    else
      redirect_to event_path(event), notice: 'Interest not added'
    end
  end

  def destroy
    Event.find(params[:event_id]).event_interests.find_by(interest_id: params[:interest_id]).delete
    redirect_back(fallback_location: root_path)
  end

  def update
    if params[:interests].nil?
      redirect_to edit_event_interests_path(params[:id]), alert: 'Please select at least one interest'
      return
    end

    @event = Event.find(params[:id])
    if @event.status == 'locating'
      if @event.editing
        @event.status = 'completed'
        @event.editing = false
        @event.finished = true
      else
        @event.status = 'interest_adding'
      end
    end

    @event.save
    @event.event_interests.destroy_all

    params[:interests].each do |interest|
      EventInterest.new(interest_id: interest[0], event_id: @event.id).save
    end

    redirect_to step_event_path(@event), notice: 'Interests added'
  end
end
