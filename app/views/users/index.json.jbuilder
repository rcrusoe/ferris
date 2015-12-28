json.array!(@users) do |user|
  json.extract! user, :id, :phone_number, :name, :email, :neighborhood, :number_of_conversations, :needs_response
  json.url user_url(user, format: :json)
end
