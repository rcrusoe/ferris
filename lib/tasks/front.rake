namespace :front do
  URL = 'https://api.frontapp.com/companies/ferris/inboxes/kz3/conversations/all'
  USERNAME = 'ferris'
  PASSWORD = 'bb2322077886e32690b7d875f89633de'
  OBJECTS_PER_PAGE = 10
  HOURS_BETWEEN_CONVO = 18

  desc 'Load all existing conversations and messages from Front'
  task :get_conversations => :environment do
    # get a list of all messages for user from front, then break up into conversations
    get_all_conversations.each do |c|
      if c['message_type'] == 'sms'

        # get the conversation object from front
        conversation_json = get_conversation(c['url'])
        user_created_at = Time.at(conversation_json['created_at']/1000)
        # first create a user if phone number does not exist
        user = User.where(phone_number: c['recipient']['handle'], created_at: user_created_at).first_or_create
        ap user

        # for each message check timestamp, assign to conversation, save
        conversation = nil
        previous_message = nil
        conversation_json['messages'].reverse!.each do |m| # reverse to put the oldest messages first
          message = Message.new(body: get_message_body(m['url']),
                                inbound: m['inbound'])
          message.created_at = Time.at(m['date']/1000)

          # if time since last message is outside threshold, create a new conversation
          if previous_message.nil? || hours_between(message.created_at, previous_message.created_at) > HOURS_BETWEEN_CONVO
            conversation = Conversation.where(user: user, created_at: message.created_at).first_or_create
            # TODO: add conversation tags
            ap conversation
          end

          # set the message conversation
          message.conversation = conversation

          # save and continue
          message.save
          previous_message = message
          ap message
        end
      end
    end
  end

  private

  # returns a JSON conversation list from front
  def get_all_conversations
    response = RestClient::Request.execute method: :get,
                                           url: URL,
                                           user: USERNAME,
                                           password: PASSWORD,
                                           headers: {params: {pageSize: OBJECTS_PER_PAGE, page:0}},
                                           :content_type => :json,
                                           :accept => :json
    JSON(response)['conversations']
  end

  # returns a conversation JSON object from front
  def get_conversation(url)
    # url = 'https://api.frontapp.com/companies/ferris/conversations/18blgo'
    conversation = RestClient::Request.execute method: :get,
                                               url: url,
                                               user: USERNAME,
                                               password: PASSWORD,
                                               :content_type => :json,
                                               :accept => :json
    JSON(conversation)
  end

  # returns a message body string from front
  def get_message_body(url)
    message = RestClient::Request.execute method: :get,
                                               url: url,
                                               user: USERNAME,
                                               password: PASSWORD,
                                               :content_type => :json,
                                               :accept => :json
    JSON(message)['text']
  end

  # hours between two messages
  def hours_between(date1, date2)
    ((date2 - date1) / 1.hour).abs.round
  end
end