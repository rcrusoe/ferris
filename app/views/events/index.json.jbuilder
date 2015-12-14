json.array!(@events) do |event|
  json.extract! event, :id, :title, :description, :date, :start_time, :end_time, :address, :neighborhood, :website, :price, :purchase_url
  json.url event_url(event, format: :json)
end
