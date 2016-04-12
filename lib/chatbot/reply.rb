module Reply
# -----------------------------------------------------------------
#  STATE 0 -- ONBOARDING
# -----------------------------------------------------------------
  HELLO_NEW = "Hi there, looks like you’re new here - I'm Ferris. What’s your name?"

  LOCAL_OR_TRAVELER = "Hey%{name}, good to meet you. Are you local to Boston, or visiting?"

  HOW_IT_WORKS = "Sweet. Well here’s how things work -\n\nI hunt in/around the city for rad new experiences, and keep you in the loop via text.\n\n"\
  "You can also text me any time to get the low down on things happening in the city. Just toss out a day..."

  #  first ask where --> is there a specific part of town you'd like to explore -- Downtown, Southie, Harvard Square?
  HOW_IT_WORKS_TOURIST = "Welcome to Boston. Can I help you find an event, tourist attraction, or restaurant?"
# -----------------------------------------------------------------
#  STATE 1 -- WHEN
# -----------------------------------------------------------------
  HELLO_NAME = "Hello again%{name}, when are you looking for something to do?"

  WHEN_TRY_AGAIN = "Didn't quite get that, can you explain with words like ‘tomorrow’, ‘today’, ‘later this week'?"

# -----------------------------------------------------------------
#  STATE 2 -- WHAT
# -----------------------------------------------------------------
#   TODO: generate appended categories based on user interest graph
  WHAT = "Sure! Are you in the moood for something specific like live music or comedy? Or do you just want to browse my personal top picks?"

  MORE_DETAIL = "Adjectives are a good start, but give me some nouns to work with here. Art? Jazz? Bars? Hiking? Comedy? What are you in the mood for?"

  HELP = "I should be up front with you%{name} - I'm a bot trained by humans. I wasn't able to find anything"

# -----------------------------------------------------------------
#  STATE 3 -- GIVING RECOMMENDATIONS
# -----------------------------------------------------------------
  HOLD_ON = "Solid choices%{name}, you've got options. Give me a minute to scope it out for you"
  IN_THE_MEANTIME = "In the meantime -- Is there any way you could help contribute to the community? Maybe sign up to be an ambassador?
                     We know you've got some good recommendations to share."

  EVENT_DETAILS = "%{title} is happening %{date} at%{time} in %{location} --> %{url}"

  # sign up for pull. so do you want to join The List?
  # WELCOME = "Here's how this works. You can join us, but you need to pull your weight. I expect you to send me cool things you find
  #            going on in the city every week. I'll do the same."


  WILLING = "I should be up front with you %{name} - I'm a bot trained by humans. Would you be willing to work with me and other cool people in your
          city to curate an epic list of the best weekly spots, events, and activities?"

  # Any of those seem like your cup of tea?
  # TODO: Sentiment analysis

  # GIVE SECOND SET OF RECOMMENDATIONS

  # If still not satisfied -> push into browsing experience
  # OR
  # Ask if they'd like to



  # End of conversation, create an ongoing conversation bridge
  ARE_YOU_SURE = "Are you actually considering going to one of those places or do you want more options? Be honest with me %name"
  CHECK_IN_TOMORROW = "I'll be checking in tomorrow to hear how you liked it."

# -----------------------------------------------------------------
#  RANDOM RESPONSES
# -----------------------------------------------------------------
  I_AM_A_BOT = "That's a difficult question to answer. I use artificial intelligence, but humans train me."
end