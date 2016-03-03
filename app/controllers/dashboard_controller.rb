class DashboardController < ApplicationController
  MAX_CONVERSATIONS = 7

  def index
    @total_conversations = Conversation.count
    @total_users = User.count
    @repeat_users = User.where('conversations_count > 1')

    convo_buckets = Hash.new(0)
    @bar_chart = [] # list of tuples with the label and user count per number of conversations
    averages = []
    # for every user with multiple conversations, calculate avg days between
    @repeat_users.each do |user|
      # take the span between first and last conversation date
      span_days = (user.conversations.last.created_at.to_date - user.conversations.first.created_at.to_date).to_i
      # divide by number of conversations
      avg_days = span_days / user.conversations.count
      averages << avg_days
      ap averages
    end

    unless @repeat_users.empty?
      @avg_days = (averages.reduce(:+) / averages.size).round

      # bucket users by number of conversations and put in hash for bar chart
      (2..MAX_CONVERSATIONS).each do |i|
        users_per_convo = User.where("conversations_count = #{i}").count
        convo_buckets[i] += users_per_convo
      end

      convo_buckets.each do |key, value|
        @bar_chart << [key, value]
      end
    end
    js :URL => request.original_url
  end

  # receive a period (today, this week, this month) and return key metrics to display
  def metrics
    period = params[:period].to_i
    case period
      when 0
        range = Date.today.beginning_of_day..Date.today.end_of_day
      when 1
        range = Date.yesterday.beginning_of_day..Date.yesterday.end_of_day
      when 2 # This Week
        range = Date.today.at_beginning_of_week.beginning_of_day..Date.today.at_end_of_week.end_of_day
      when 3 # Last Week
        range = 1.week.ago.at_beginning_of_week.beginning_of_day..1.week.ago.at_end_of_week.end_of_day
      when 4 # This Month
        range = Date.today.beginning_of_month.beginning_of_day..Date.today.end_of_month.end_of_day
      when 5 # Last Month
        range = 1.month.ago.beginning_of_month.beginning_of_day..1.month.ago.end_of_month.end_of_day
      else # default to Today
        range = Date.today.beginning_of_day..Date.today.end_of_day
    end

    # Query Database with date range
    conversations = Conversation.where(created_at: range).count
    new_users = User.where(created_at: range, conversations_count: 1).count
    repeat_users = User.where('conversations_count > 1').joins(:conversations).where(conversations: {:created_at => range}).uniq.count
    conversation_buckets = Conversation.group_by_day(:created_at, range: range).count

    render json: {conversations: conversations,
                  new_users: new_users,
                  repeat_users: repeat_users,
                  conversation_buckets: conversation_buckets.values,
                  dates: conversation_buckets.keys.map! {|d| d.strftime("%-m/%-d")} }
  end
end
