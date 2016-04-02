class FrontController < ApplicationController
  HOURS_BETWEEN_CONVO = 18
  API_TOKEN = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJyb2xlIjoiY29tcGFueSIsImNvbXBhbnkiOiJmZXJyaXMifQ.0wDOV0pX-CG-SF7XjTZWPVUYeFCq_20FbAUg_9-m7qc'
  URL = 'https://api2.frontapp.com/conversations/{conversation_id}/messages'

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

    # if first message, say hello
    if conversation.messages_count == 1
      send_text('Hey there, are you looking for something to do tonight or later this week?')
    else
      if str_to_range(text)
        event = Event.where(date: str_to_range(text)).sample
        send_text(event.title + ' is happening on' + event.next.date.strftime("%A, %B #{event.next.date.day.ordinalize}"))
      else
        send_text('date not parsed')
      end
    end

    render nothing: true, status: :ok
  end

  private

  # hours between two messages
  def hours_between(date1, date2)
    ((date2 - date1) / 1.hour).abs.round
  end

  def send_text(msg)
    account_sid = 'AC4483ffd246d56ac3e099e4ef55d01bfd'
    auth_token = '51ff1297e63e8e58ef5158876bc0b36c'
    client = Twilio::REST::Client.new account_sid, auth_token
    client.account.messages.create(
        :from => '+16177588031',
        :to => '+15087375910',
        :body => msg
    )
  end

  def str_to_range(s)
    AlchemyAPI.key = "f286fcd06ef13744899ce740524ef099560102e4"
    s.gsub!('!', '')
    s.gsub!('?', '') if s.chars.count > 1
    s.gsub!('/', ' ')
    # ap s
    parsed = Chronic.parse(s, :guess => false)

    if parsed.nil?
      n = Nickel.parse s
      if n.occurrences.any?
        parsed = n.occurrences[0].start_date.date
      end
    end

    # second fallback is on Alchemy API
    if parsed.nil?
      results = AlchemyAPI.search(:keyword_extraction, text: s)
      results.each do |r|
        parsed = Chronic.parse(r['text'], :guess => false)
        if parsed.nil?
          n = Nickel.parse r['text']
          if n.occurrences.any?
            parsed = n.occurrences[0].start_date.date
          end
        end
        break unless parsed.nil?
      end
    end

    # manually check for certain ones
    if s.downcase == 'later' || s.downcase == 'both'
      parsed = Date.today
    end

    parsed
  end

end