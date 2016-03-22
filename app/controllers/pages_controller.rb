class PagesController < ApplicationController
  # quick and dirty CI recommendation test (NEVER WRITE FRONT END CODE LIKE THIS OUTSIDE TESTING)
  def rec
    names = ['Allison', 'Joe', 'Jack', 'Bob', 'Fred']
    messages = ['I like food', 'I like music', 'Movies are fun', 'Need a date night', 'Alcohol and Breasts']
    @events = Event.limit(3).order('RANDOM()')

    if params[:index]
      index = params[:index].to_i
    else
      index = 0
    end

    @name = names[index]
    @message = messages[index]
    # @event1 = events[0]
    # @event2 = events[1]
    # @event3 = events[2]

    js :URL => request.base_url, :index => index
  end
end
