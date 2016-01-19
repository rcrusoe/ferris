json.array!(@places) do |place|
  json.extract! place, :id, :name, :description, :address, :neighborhood, :website, :phone_number, :monday_open, :monday_open_time, :monday_close_time, :tuesday_open, :tuesday_open_time, :tuesday_close_time, :wednesday_open, :wednesday_open_time, :wednesday_close_time, :thursday_open, :thursday_open_time, :thursday_close_time, :friday_open, :friday_open_time, :friday_close_time, :saturday_open, :saturday_open_time, :saturday_close_time, :sunday_open, :sunday_open_time, :sunday_close_time
  json.url place_url(place, format: :json)
end
