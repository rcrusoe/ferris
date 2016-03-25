class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  # GET /places
  # GET /places.json
  def index
    authenticate
    @places = Place.where(approved: true)
  end

  def import
    authenticate
    @places = Place.where(approved: false)
  end

  # GET /places/1
  # GET /places/1.json
  def show
    @open_hours = Hash.new
    @place.open_times.each do |schedule|
      @open_hours[schedule.day] = "#{schedule.open_time.strftime('%l:%M %P')} - #{schedule.close_time.strftime('%l:%M %P')}"
    end
  end

  # GET /places/new
  def new
    @place = Place.new
  end

  # GET /places/1/edit
  def edit
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(place_params)

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render :show, status: :created, location: @place }
      else
        format.html { render :new }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /places/1
  # PATCH/PUT /places/1.json
  def update
    respond_to do |format|
      if @place.update(place_params)
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { render :show, status: :ok, location: @place }
      else
        format.html { render :edit }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    # if the place was unapproved, add it to our import blacklist
    unless @place.approved?
      Blacklist.create(fb_id: @place.fb_id, name: @place.name)
    end

    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url, notice: 'Place was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:name, :description, :full_address, :website, :phone_number, :image, :approved, :neighborhood, open_times_attributes: [:id, :day, :open_time, :close_time, :_destroy])
    end
end
