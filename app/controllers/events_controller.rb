class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show past upcoming]
  before_action :set_event, only: %i[show edit update destroy reset step completed edit_location edit_interests]
  before_action :check_event!, only: %i[edit update destroy reset step completed]
  before_action :check_for_organizer, only: %i[new create edit update destroy reset step completed]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show; end

  # GET /events/upcoming
  def past
    @events = Event.all
  end

  # GET /events/past
  def upcoming
    @events = Event.all
  end

  # GET /events/today
  def today
    @events = Event.all
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    if @event.status != 'completed'
      redirect_to step_event_path(@event.short_name)
    end
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.organizer_id = current_user.profile.organizer.id

    respond_to do |format|
      if @event.save
        set_event_short_name
        next_step
        format.html { redirect_to step_event_path(@event.short_name), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    check_for_location
    respond_to do |format|
      if @event.update(event_params)
        next_step
        format.html { redirect_to step_event_path(@event.short_name), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity, notice: "Event was not updated." }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.interests.destroy_all
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /states/:country
  def obtain_states
    states = CS.states(params[:country])
    if states.nil? || states.empty?
      render json: {"" => "", "No states found" => "No states found"}.to_json
    else
      render json: states.to_json
    end
  end

  # GET /cities/:state
  def obtain_cities
    cities = CS.cities(params[:state], params[:country])
    if cities.nil? || cities.empty? || params[:state] == "No states found"
      render json: {"" => "", "No cities found" => "No cities found"}.to_json
    else
      render json: cities.to_json
    end
  end

  # GET /events/:id/step
  def step
    return redirect_to edit_event_path(@event.short_name) if @event.status == 'completed' && @event.editing == false

    if @event.organizer_id != current_user.profile.organizer.id
      redirect_to event_path(@event.short_name), notice: 'You are not the organizer of this event'
    end
  end

  # PATCH /events/:id/completed
  def completed
    if @event.organizer_id != current_user.profile.organizer.id
      redirect_to event_path(@event.short_name), notice: 'You are not the organizer of this event'
    end

    unless @event.status == 'confirming'
      redirect_to step_event_path(@event.short_name), notice: 'You need to complete the event'
      return
    end

    @event.status = 'completed'
    @event.finished = true
    @event.save
    redirect_to edit_event_path(@event.short_name), notice: 'Event completed'
  end

  # PATCH /events/:id/reset
  def reset
    if @event.organizer_id != current_user.profile.organizer.id
      redirect_to event_path(@event.short_name), notice: 'You are not the organizer of this event'
    end

    @event.status = 'draft'
    @event.finished = false
    @event.country = nil
    @event.state = nil
    @event.city = nil
    @event.save
    redirect_to step_event_path(@event.short_name), notice: 'Event reset'
  end

  # PATCH /events/:id/interests
  def edit_interests
    if @event.organizer_id != current_user.profile.organizer.id
      redirect_to event_path(@event.short_name), notice: 'You are not the organizer of this event'
    end

    unless @event.status == 'completed'
      redirect_to step_event_path(@event.short_name), notice: 'You need to complete the event'
      return
    end

    @event.status = 'locating'
    @event.editing = true
    @event.finished = false
    @event.save
    redirect_to step_event_path(@event.short_name)
  end

  # PATCH /events/:id/location
  def edit_location
    if @event.organizer_id != current_user.profile.organizer.id
      redirect_to event_path(@event.short_name), notice: 'You are not the organizer of this event'
    end

    unless @event.status == 'completed'
      redirect_to step_event_path(@event.short_name), notice: 'You need to complete the event'
      return
    end

    @event.status = 'created'
    @event.editing = true
    @event.finished = false
    @event.country = nil
    @event.state = nil
    @event.city = nil
    @event.save
    redirect_to step_event_path(@event.short_name)
  end

  private

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description, :date, :hour, :country, :date_ending, :hour_ending,
                                  :state, :city, :is_virtual?, :interests, :public)
  end

  # Check if the user is an organizer
  def check_for_organizer
    unless current_user.profile.organizer
      redirect_to new_organizer_path, notice: 'You need to be an organizer to create an event'
    end
  end

  # Check if the event has a location
  def check_for_location
    return unless @event.status == 'locating' || !@event.is_virtual? == 'Virtual'

    if @event.country == '' || @event.state == '' || @event.city == ''
      redirect_to step_event_path(@event.short_name), notice: 'You need to select a location'
    end
  end

  # update the event step
  def next_step
    if @event.editing
      if @event.country.nil? || @event.state.nil? || @event.city.nil?
        @event.status = 'created' if @event.status == 'created'
      else
        @event.status = 'completed'
        @event.editing = false
        @event.finished = true
      end
    else
      if @event.status == 'draft'
        if @event.is_virtual? == 'Virtual'
          @event.status = 'locating'
        else
          @event.status = 'created'
        end
      elsif @event.status == 'created'
        if @event.country.nil? || @event.state.nil? || @event.city.nil?
          @event.status = 'created'
        else
          @event.status = 'locating'
        end
      elsif @event.status == 'interest_adding'
        @event.status = 'confirming'
      elsif @event.status == 'confirming'
        @event.status = 'completed'
      end
    end
    @event.save
  end

  def set_event_short_name
    @event.short_name = @event.name.downcase.truncate(50).gsub(' ', '-').gsub(/[^\w-]/, '')
    @event.save
  end
end
