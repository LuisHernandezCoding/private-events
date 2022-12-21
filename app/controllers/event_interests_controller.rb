class EventInterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[create update destroy]
  before_action :check_event!

  # POST /events/:id/interests
  def create
    interest = @event.event_interests.new(interest_id: params[:interest_id])
    if interest.save 
      redirect_back(fallback_location: root_path)
    else
      redirect_to event_path(@event), notice: 'Interest not added'
    end
  end

  # DELETE /events/:id/interests/
  def destroy
    @event.event_interests.find_by(interest_id: params[:interest_id]).delete
    redirect_back(fallback_location: root_path)
  end

  # PATCH /events/:id/interests
  def update
    if params[:interests].nil?
      redirect_to edit_event_interests_path(params[:id]), alert: 'Please select at least one interest'
      return
    end

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
