class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    # authenticate

    # Parse Filters from Nav Bar

    # DATE RANGE
    period = 5 # default is next 2 weeks
    if params[:when]
      period = params[:when].to_i
    end

    case period
      when 1 # Today
        range = Date.current
      when 2 # Tomorrow
        range = Date.current.tomorrow
      when 3 # This Week
        range = Date.current..Date.current.at_end_of_week
      when 4 # This Weekend
        range = Date.current.at_end_of_week - 2.days..Date.current.at_end_of_week
      when 5 # Next Two Weeks
        range = Date.current..Date.current + 2.weeks
    end

    @event_instances = Occurrence.where(date: range).joins(:event).where('events.approved = true').order('date', 'events.start_time')

    # LOCATION
    # if Boston, Cambridge, Somerville: all events with place.city == "Boston"
    if params[:where]
      location = params[:where]
      if location == 'Boston' || location == 'Cambridge' || location == 'Somerville'
        @event_instances = @event_instances.joins(event: :place).where('places.city = ?', location)
      else
        @event_instances = @event_instances.joins(event: :place).where('places.neighborhood = ?', location)
      end
    end

    # CATEGORIES
    if params[:what]
      categories = params[:what].split(',')
      @event_instances = @event_instances.joins(event: :category).where('categories.name in (?)', categories)
    end

    js :URL => request.original_url.split('?').first, :when => period, :where => location, :what => categories
  end

  def import
    authenticate

    if params[:search]
      events = Event.where(approved: false).includes(:occurrences, :place).search(params[:search])
    else
      events = Event.where(approved: false).includes(:occurrences, :place).order(interested_count: :desc)
    end

    # TODO: will this be efficient for 500+ events?
    @event_instances = events.map { |e| e.occurrences }.flatten!#.sort_by {|o| [o.date, o.event.start_time]}
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    js :URL => request.base_url
  end

  # GET /events/1/edit
  def edit
    js :new, :URL => request.base_url # execute same javascript as new
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    # if the event was unapproved, add it to our import blacklist
    unless @event.approved?
      Blacklist.create(fb_id: @event.fb_id, name: @event.title)
    end

    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # input is place_id, output is address and location strings in a json hash
  def get_address_and_loc
    id = params[:place_id].to_i
    place = Place.find(id)
    render json: { address: place.address, loc: place.neighborhood }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :place_id, :category_id, :date, :start_time, :end_time, :address, :neighborhood, :website, :price, :purchase_url, :image, :short_blurb, :recurrence, :approved)
  end
end
