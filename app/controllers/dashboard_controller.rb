class DashboardController < ApplicationController
  MAX_CONVERSATIONS = 10

  def index
    # authenticate

    @total_conversations = Conversation.count
    @total_users = User.count
    @repeat_users = User.where('conversations_count > 1').includes(:conversations)
    repeat_users_last_30_days = User.where('conversations_count > 1').joins(:conversations)
                                    .where(conversations: {:created_at => 2.month.ago..Date.current.end_of_day}).uniq

    convo_buckets = Hash.new(0)
    @bar_chart = [] # list of tuples with the label and user count per number of conversations
    averages = []
    # for every user with multiple conversations, calculate avg days between
    repeat_users_last_30_days.each do |user|
      # take the span between first and last conversation date
      span_days = (user.conversations.last.created_at.to_date - user.conversations.first.created_at.to_date).to_i
      # divide by number of conversations
      avg_days = span_days.to_f / user.conversations_count
      averages << avg_days
    end

    unless @repeat_users.empty?
      @avg_days = (averages.reduce(:+) / averages.size).round(2)

      # bucket users by number of conversations and put in hash for bar chart
      (2..MAX_CONVERSATIONS).each do |i|
        users_per_convo = User.where("conversations_count = #{i}").count
        convo_buckets[i] += users_per_convo
      end

      convo_buckets.each do |key, value|
        @bar_chart << [key, value]
      end
    end
    js :URL => request.original_url # TODO: move to config file
  end

  # receive a period (today, this week, this month) and return key metrics to display
  def metrics
    period = params[:period].to_i
    case period
      when 0
        range = Date.current.beginning_of_day..Date.current.end_of_day
      when 1
        range = Date.current.yesterday.beginning_of_day..Date.current.yesterday.end_of_day
      when 2 # This Week
        range = Date.current.at_beginning_of_week.beginning_of_day..Date.current.at_end_of_week.end_of_day
      when 3 # Last Week
        range = 1.week.ago.at_beginning_of_week.beginning_of_day..1.week.ago.at_end_of_week.end_of_day
      when 4 # This Month
        range = Date.current.beginning_of_month.beginning_of_day..Date.current.end_of_month.end_of_day
      when 5 # Last Month
        range = 1.month.ago.beginning_of_month.beginning_of_day..1.month.ago.end_of_month.end_of_day
      when 6 # Last 3 Month
        range = 3.month.ago.beginning_of_month.beginning_of_day..Date.current.end_of_month.end_of_day
      else # default to Today
        range = Date.current.beginning_of_day..Date.current.end_of_day
    end

    # Query Database with date range
    conversations = Conversation.where(created_at: range).count
    new_users = User.where(created_at: range).count
    repeat_users = User.where('conversations_count > 1').joins(:conversations).where(conversations: {:created_at => range}).uniq.count

    if period == 6
      conversation_buckets = Conversation.group_by_week(:created_at, week_start: :mon, range: range).count
    else
      conversation_buckets = Conversation.group_by_day(:created_at, range: range).count
    end

    # Retention Chart
    retention_data = {
        weeks: [],
        data: []
    }

    # grab all users, bucketed by creation date
    user_buckets = User.where(created_at: 12.weeks.ago.beginning_of_week.beginning_of_day..Date.current.end_of_day).select(:id, :created_at).group_by{ |u| u.created_at.beginning_of_week }

    cell = [0,0,0]
    first_week = true
    # for each bucket, loop over 12 weeks and count conversations with a user_id in the cohort
    user_buckets.sort.each do |k,v|
      user_ids = v.map! {|u| u.id }
      start = k.to_date.beginning_of_day
      retention_data[:weeks] << "#{start.strftime('%b %-d')} -- #{user_ids.count} users"

      until start > Date.current.end_of_week
        cell_range = start..start+1.week

        if first_week
          returning_users = user_ids.count - User.where(id: user_ids).joins(:conversations).where(conversations: {:created_at => cell_range}).uniq.count
          first_week = false
        else
          returning_users = Conversation.where(created_at: cell_range, user_id: user_ids).uniq.pluck(:user_id).count
        end
        cell[2] = ((returning_users.to_f / user_ids.count) * 100).round(1)
        retention_data[:data] << cell.dup
        start += 1.week
        cell[0] += 1
      end

      cell[1] += 1
      cell[0] = 0
      first_week = true
    end

    render json: {conversations: conversations,
                  new_users: new_users,
                  repeat_users: repeat_users,
                  conversation_buckets: conversation_buckets.values,
                  dates: conversation_buckets.keys.map! {|d| d.strftime('%-m/%-d')},
                  retention: retention_data}
  end
end
