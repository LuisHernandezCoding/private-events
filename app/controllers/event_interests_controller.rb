class EventInterestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[create update destroy]
  before_action :check_event!

  # POST /events/:short_name/interests
  def create
    interest = @event.event_interests.new(interest_id: params[:interest_id])
    if interest.save 
      redirect_back(fallback_location: root_path)
    else
      redirect_to event_path(@event.short_name), notice: 'Interest not added'
    end
  end

  # DELETE /events/:short_name/interests/
  def destroy
    @event.event_interests.find_by(interest_id: params[:interest_id]).delete
    redirect_back(fallback_location: root_path)
  end

  # PATCH /events/:short_name/interests
  def update
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

    if params[:interests].present?
      params[:interests].each do |interest|
        EventInterest.new(interest_id: interest[0], event_id: @event.id).save
      end
    end

    redirect_to step_event_path(@event.short_name), notice: 'Interests added'
  end
end
