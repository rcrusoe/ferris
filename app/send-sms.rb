require 'rubygems'
require 'twilio-ruby'
require 'sinatra'
 
account_sid = "AC4483ffd246d56ac3e099e4ef55d01bfd"
auth_token = "51ff1297e63e8e58ef5158876bc0b36c"
client = Twilio::REST::Client.new account_sid, auth_token
 
from = "+16176827760" # Your Twilio number
 
friends = {
	"+18452640419" => "Robinson",
}
friends.each do |key, value|
  client.account.messages.create(
    :from => from,
    :to => key,
    :body => "Hey #{value}, Monkey party at 6PM. Bring Bananas!"
  )
  puts "Sent message to #{value}"
end