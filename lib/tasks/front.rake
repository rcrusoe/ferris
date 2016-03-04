require 'csv'

namespace :front do
  URL = 'https://api.frontapp.com/companies/ferris/inboxes/kz3/conversations/all'
  # TODO: move credentials to ENV variable on Heroku
  USERNAME = 'ferris'
  PASSWORD = 'bb2322077886e32690b7d875f89633de'
  OBJECTS_PER_PAGE = 1000
  HOURS_BETWEEN_CONVO = 18

  desc 'Load all existing conversations and messages from Front, takes page number as argument'
  task :get_conversations => :environment do
    ARGV.each { |a| task a.to_sym do ; end }

    # get a list of all messages for user from front, then break up into conversations
    get_all_conversations.each do |c|
      if c['message_type'] == 'sms'

        # get the conversation object from front
        conversation_json = get_conversation(c['url'])
        user_created_at = Time.at(conversation_json['created_at']/1000)

        # create or find the user
        user = User.where(phone_number: c['recipient']['handle']).first_or_create do |u|
          u.created_at = user_created_at
        end
        ap user

        # for each message check timestamp, assign to conversation, save
        conversation = nil
        previous_message = nil
        conversation_json['messages'].reverse!.each do |m| # reverse to put the oldest messages first
          message = Message.new(body: get_message_body(m['url']), inbound: m['inbound'])
          message.created_at = Time.at(m['date']/1000)

          # if time since last message is outside threshold, create a new conversation
          if previous_message.nil? || (m['inbound'] && hours_between(message.created_at, previous_message.created_at) > HOURS_BETWEEN_CONVO)
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

  desc 'total number of conversations to migrate from Front'
  task :count => :environment do
    ARGV.each { |a| task a.to_sym do ; end }
    ap get_all_conversations.find_index {|c| c['recipient']['handle'] == '+19199248897'}
  end

  desc 'Pull conversations from google voice csv'
  task :google_voice => :environment do
    CSV.foreach(Rails.root + 'db/google-voice.csv') do |row|
      number = "+#{row[0]}"
      time = DateTime.strptime(row[1], '%m/%d/%Y')
      # create or find the user
      user = User.where(phone_number:number).first_or_create do |u|
        u.created_at = time
      end
      conversation = Conversation.where(user: user, created_at: time).first_or_create
      ap user
      ap conversation
    end
  end

  private

  # returns a JSON conversation list from front
  def get_all_conversations
    response = RestClient::Request.execute method: :get,
                                           url: URL,
                                           user: USERNAME,
                                           password: PASSWORD,
                                           headers: {params: {pageSize: OBJECTS_PER_PAGE, page:ARGV[1]}},
                                           :content_type => :json,
                                           :accept => :json
    JSON(response)['conversations'][229..-1]
  end

  # returns a conversation JSON object from front
  def get_conversation(url)
    response = RestClient::Request.execute method: :get,
                                               url: url,
                                               user: USERNAME,
                                               password: PASSWORD,
                                               :content_type => :json,
                                               :accept => :json

    if response.headers[:x_ratelimit_remaining].to_i < 3
      reset_time = Time.at(response.headers[:x_ratelimit_reset].to_i)
      delay = (reset_time - Time.now) + 5
      puts 'SLEEPING FOR: '+ delay.to_s
      sleep delay
    end

    JSON(response)
  end

  # returns a message body string from front
  def get_message_body(url)
    response = RestClient::Request.execute method: :get,
                                          url: url,
                                          user: USERNAME,
                                          password: PASSWORD,
                                          :content_type => :json,
                                          :accept => :json

    if response.headers[:x_ratelimit_remaining].to_i < 3
      reset_time = Time.at(response.headers[:x_ratelimit_reset].to_i)
      delay = (reset_time - Time.now) + 5
      puts 'SLEEPING FOR: '+ delay.to_s
      sleep delay
    end

    JSON(response)['text']
  end

  # hours between two messages
  def hours_between(date1, date2)
    ((date2 - date1) / 1.hour).abs.round
  end
end