# handles sending / recieving of SMS messages
class FrontController < ApplicationController
  HOURS_BETWEEN_CONVO = 18
  API_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiY29tcGFueSIsImNvbXBhbnkiOiJmZXJyaXMifQ.0wDOV0pX-CG-SF7XjTZWPVUYeFCq_20FbAUg_9-m7qc'

  # Any time new message is sent from Front, webhook passes event data to this endpoint
  def mirror
    number = params['message']['conversation']['recipient']['handle']
    date = Time.at(params['message']['date']/1000)
    inbound = params['message']['inbound']
    text = params['message']['text']

    # create or find the user
    user = User.where(phone_number: number).first_or_create do |u|
      u.created_at = date
      puts "New user created for #{number}"
    end

    # find the most recent conversation or create a new one
    conversation = Conversation.where(user: user).order(:created_at).last
    last_message = conversation.messages.order(:created_at).last if conversation

    # if time since last message is outside threshold, create a new conversation
    if last_message.nil? || (inbound && hours_between(date, last_message.created_at) > HOURS_BETWEEN_CONVO)
      conversation = Conversation.create(user: user, created_at: date)
      ap conversation
    end

    # create the message
    message = Message.new(body: text, inbound: inbound)
    message.created_at = date
    message.conversation = conversation
    message.save
    ap message

    render nothing: true, status: :ok
  end

  # test webhook for automated conversation flow
  def bot
    number = params['message']['conversation']['recipient']['handle']

    date = Time.at(params['message']['date']/1000)
    inbound = params['message']['inbound']
    text = params['message']['text']

    # create or find the user
    user = User.where(phone_number: number).first_or_create do |u|
      u.created_at = date
      puts "New user created for #{number}"
    end

    # find the most recent conversation or create a new one
    conversation = Conversation.where(user: user).order(:created_at).last
    last_message = conversation.messages.order(:created_at).last if conversation

    # if time since last message is outside threshold, create a new conversation
    if last_message.nil? || (inbound && hours_between(date, last_message.created_at) > HOURS_BETWEEN_CONVO)
      conversation = Conversation.create(user: user, created_at: date)
      ap conversation
    end

    # create the message
    message = Message.new(body: text, inbound: inbound)
    message.created_at = date
    message.conversation = conversation
    message.save
    ap message

    # send a reply
    send_text(ChatManager.new(conversation).reply(text), number)

    render nothing: true, status: :ok
  end

  private

  # hours between two messages
  def hours_between(date1, date2)
    ((date2 - date1) / 1.hour).abs.round
  end

  def send_text(messages, number)
    account_sid = 'AC4483ffd246d56ac3e099e4ef55d01bfd'
    auth_token = '51ff1297e63e8e58ef5158876bc0b36c'
    client = Twilio::REST::Client.new account_sid, auth_token
    messages.each do |msg|
      client.account.messages.create(
          :from => '+16177588031',
          :to => number,
          :body => msg
      )
      sleep 2
    end
  end

end