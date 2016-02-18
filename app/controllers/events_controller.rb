class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    if Rails.env.production?
      authenticate
    end
    if params[:search]
      @events = Event.search(params[:search]).order('events.date, events.start_time')
    else
      @events = Event.all.order('events.date, events.start_time')
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    if params[:id]
      @event = Event.find(params[:id]).dup
    else
      @event = Event.new
    end
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)
    respond_to do |format|
      if @event.save
        if params[:addDate]
          format.html { redirect_to controller: 'events', action: 'new', id: @event.id }
          format.json { render :show, status: :created, location: @event }
        else
          format.html { redirect_to @event, notice: 'Event was successfully created.' }
          format.json { render :show, status: :created, location: @event }
        end
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
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:title, :description, :date, :start_time, :end_time, :address, :neighborhood, :website, :price, :purchase_url, :image, :short_blurb, :repeat_weekly)
  end

  # events page is internal
  def authenticate
    authenticate_or_request_with_http_basic('Events archive is private.') do |username, password|
      username == 'ferris' && password == 'boston'
    end
  end
end
