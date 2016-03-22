class PagesController < ApplicationController
  # quick and dirty CI recommendation test (NEVER WRITE FRONT END CODE LIKE THIS OUTSIDE TESTING)
  def rec
    names = ['Dustin', 'Jessica', 'Ken', 'Roxana', 'M', 'Matt', 'Julia', 'Leyla', 'Tonia', 'Heidi']
    messages = ["I'm trying to go out and check out the city and have fun",
                "We wanna do some things kind of adventurous and anything involving some drinking! We're 23-26 years old.",
                "Sports sneakers trivia", "Umm, movies, theatre, food, history",
                "Surprise me",
                "Tonight after my 6:30 dinner at beehive, I wanted to do something fun with this girl I've been seeing. Originally I was thinking paint bar but that's full…",
                "Just looking for fun things to do, here visiting for the week and it's hard to find what's going on!",
                "Maybe a play or a show, or oysters somewhere? I'm traveling alone.",
                "Lol this is cool. Today. We're looking for free events or particularly inexpensive",
                "I'm visiting but I want to do a bit of everything. I've done the movies and karaoke and stuff",
                "Fun things to do in Boston for a 15 yr old a senior citizen and a 40 year old"]
    options = [[518, 522, 516],
               [525, 577, 467],
               [510, 582, 531],
               [582, 516, 518],
               [520, 532, 488],
               [467, 577, 469],
               [522, 521, 515],
               [520, 488, 529],
               [563, 562, 482],
               [482, 564, 563]]

    if params[:index]
      index = params[:index].to_i
    else
      index = 0
    end

    @name = names[index]
    @message = messages[index]
    @events = []
    @events << Event.find(options[index][0])
    @events << Event.find(options[index][1])
    @events << Event.find(options[index][2])

    js :URL => request.base_url, :index => index
  end
end
