module Tags
  CATEGORIES = ['Music', 'Comedy', 'Art', 'Theater', 'Museum', 'Nightlife', 'Food', 'Film',
                'Culture', 'Sport', 'Tech', 'Outdoor']

  CATEGORIZED_KEYWORDS = {
      music: ['concert', 'show', 'venue', 'music', 'entertainment', 'band', 'festival',
              'jazz', 'hip hop', 'electronic', 'EDM', 'rock', 'alternative', 'punk', 'dance', 'guitar', 'dj',
              'musician', 'karaoke'],
      nightlife: ['nightlife', 'wine', 'beer', 'alcohol', 'drink', 'liquor', 'bar', 'pub', 'club', 'party', 'dance', 'cocktail',
                  'margarita', 'whiskey', 'speakeasy', 'rooftop', 'brewery', 'lounge'],
      art: ['gallery', 'art', 'exhibition', 'photography', 'design'],
      theater: ['comedy', 'theater', 'theatre', 'performance', 'art', 'dance', 'improv', 'play'],
      culture: ['talk', 'lecture', 'seminar', 'poetry', 'film', 'cinema'],
      museum: ['museum', 'history', 'science', 'technology'],
      food: ['bakery', 'cook', 'snack' 'coffee', 'cafe', 'food', 'restaurant', 'eat', 'dinner', 'lunch', 'brunch',
             'breakfast', 'meal', 'dining', 'grill', 'sandwich', 'burger', 'salad', 'tapa'],
      date: ['date', 'girlfriend', 'boyfriend', 'fiance', 'husband', 'wife', 'hubby', 'bf', 'gf', 'couple'],
      family: ['kid', 'children', 'child', 'father', 'mother', 'son', 'daughter', 'family', 'minor', 'teenager'],
      outdoors: ['tour', 'outside', 'kayak', 'hike', 'hiking', 'physical', 'bike', 'biking', 'outdoor', 'recreation',
                 'health', 'fitness', 'walking', 'garden', 'park'],
      sports: ['bowling', 'pool', 'dart', 'ping pong', 'yoga'],
      misc: ['shopping', 'attraction', 'sight', 'landmark', 'trivia', 'class', 'market', 'tourist']
  }


  ADJECTIVE_KEYWORDS = ['random', 'cultural', 'interactive',
                        'casual', 'chill', 'low key', 'mellow', 'laid back', 'relaxed', 'quiet',
                        'adventurous', 'unique', 'unordinary', 'unusual',
                        'social', 'romantic', 'fancy',
                        'inside', 'outside',
                        'free', 'cheap', 'inexpensive', 'not expensive',
                        'nerdy']

  VERB_KEYWORDS = ['eat', 'meet']

  RANDOM_KEYWORDS = ['any', 'something', 'surprise', 'random']

  TIME_KEYWORDS = ['morning', 'afternoon', 'evening', 'night']

  def self.keyword?(word)
    list = CATEGORIZED_KEYWORDS.values.flatten!
    list.any? { |s| s.include?(word) }
  end
end