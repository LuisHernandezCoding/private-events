class EventAtendeesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[create destroy]

  # POST /events/:id/atendees
  def create
    atendee = @event.event_atendees.new(event: @event, profile: current_user.profile)
    if atendee.save
      redirect_back(fallback_location: root_path)
    else
      redirect_to event_path(@event), notice: 'Atendee not added'
    end
  end

  # DELETE /events/:id/atendees/
  def destroy
    atendee = @event.event_atendees.find_by(profile_id: current_user.profile.id)
    unless atendee
      redirect_to event_path(@event), notice: 'Atendee not found'
      return
    end

    atendee.delete
    redirect_back(fallback_location: root_path)
  end
end
