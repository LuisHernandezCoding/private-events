class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :check_for_organizer, only: %i[new create edit update destroy]
  before_action :check_for_event_organizer, only: %i[edit update destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)
    @event.organizer_id = current_user.profile.organizer.id

    respond_to do |format|
      if @event.save
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description, :date, :hour, :country, :state, :city, :is_virtual?)
  end

  # Check if the user is an organizer
  def check_for_organizer
    unless current_user.profile.organizer
      redirect_to new_organizer_path, notice: 'You need to be an organizer to create an event'
    end
  end

  # Check if the user is the organizer of the event
  def check_for_event_organizer
    if @event.organizer_id != current_user.profile.organizer.id
      redirect_to event_path(@event), notice: 'You are not the organizer of this event'
    end
  end
end
