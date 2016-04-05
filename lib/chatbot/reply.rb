module Reply
# -----------------------------------------------------------------
#  STATE 0 -- ONBOARDING
# -----------------------------------------------------------------
  HELLO_NEW = "Hey there, looks like you're new here - I'm Ferris. Where did you find my number?"

  LOCAL_OR_TRAVELER = "Cool cool. Choose a number 1) I'm a local 2) I'm just visiting"

  HOW_IT_WORKS = "Sweet. Here's how this works: I hunt around the city for rad new experiences, then keep you in the loop via a weekly text."\
  "You can also text me any time to see what's happening in the city."

# -----------------------------------------------------------------
#  STATE 1 -- WHEN
# -----------------------------------------------------------------
  WHEN_NEW_USER = "When are you looking for something to do -- Tonight? Later this week?"

  WHEN_REPEAT_USER_WITH_NAME = "Hola %{name}, when are you looking for something to do?"

  WHEN_REPEAT_USER_NO_NAME = "Hello again, when are you looking for something to do?"

  WHEN_TRY_AGAIN = "Didn't quite catch that, what day of the week?"

# -----------------------------------------------------------------
#  STATE 2 -- WHAT
# -----------------------------------------------------------------
  WHAT = "Roger that. What sort scene are you into -- Art? Comedy? EDM Show? Concert? Live Music? Bars?"

  MORE_DETAIL = "Adjectives are a good start, but give me some nouns to work with here. Art? Jazz? Bars? Hiking? Comedy? What are you in the mood for?"

  HELP = "I should be up front with you %{name} - I'm a bot trained by humans. I wasn't able to find anything"

# -----------------------------------------------------------------
#  STATE 3 -- GIVING RECOMMENDATIONS
# -----------------------------------------------------------------
  HOLD_ON = "Hang tight %{name}. Give me a minute to scope out what's going on in the city %{date}"
  IN_THE_MEANTIME = "In the meantime -- Is there any way you could help contribute to the community? Maybe sign up to be an ambassador?
                     We know you've got some good recommendations to share."

  EVENT_DETAILS = "%{title} is happening %{date} at%{time} in %{location} --> %{url}"

  # sign up for pull. so do you want to join The List?
  # WELCOME = "Here's how this works. You can join us, but you need to pull your weight. I expect you to send me cool things you find
  #            going on in the city every week. I'll do the same."


  WILLING = "I should be up front with you %{name} - I'm a bot trained by humans. Would you be willing to work with me and other cool people in your
          city to curate an epic list of the best weekly spots, events, and activities?"

# -----------------------------------------------------------------
#  STATE 4 -- RECOMMENDATION ACCEPTED
# -----------------------------------------------------------------

  # Any of those seem like your cup of tea?
  # TODO: Sentiment analysis

  # GIVE SECOND SET OF RECOMMENDATIONS

  # If still not satisfied -> push into browsing experience
  # OR
  # Ask if they'd like to



  # End of conversation, create an ongoing conversation bridge
  ARE_YOU_SURE = "Are you actually considering going to one of those places or do you want more options? Be honest with me %name"
  CHECK_IN_TOMORROW = "I'll be checking in tomorrow to hear how you liked it."
end