namespace :f do
  desc 'find new places, ranked by checkins or foursquare popularity'
  task :d => :environment do
    no_match_count = 0
    results = client.search_venues({near:"Cambridge, MA", categoryId:'4bf58dd8d48988d1e2931735', intent:'browse', limit:'1'})
    venues = {}
    results['venues'].each do |place|
      venue = client.venue(place['id'])
      ap venue
      # facebookID = venue['contact']['facebook']
      # if facebookID
      #   ap facebookID
      # else
      #   result = Place.where('name ILIKE ?', "%#{venue['name']}").first
      #   if result
      #     ap result.name + ' found by name'
      #   else
      #     result = Place.near([venue['location']['lat'].round(4), venue['location']['lng'].round(4)], 1).first
      #
      #     if result
      #       ap result.name + ' found by lat long'
      #     else
      #       ap 'NONE'
      #       no_match_count += 1
      #     end
      #   end
      # end

      # ap venue['categories'].map {|c| [c['name'], c['primary']] }
      # ap venue['name']
      # ap venue['categories']
      venues[venue['name']] = venue['stats']['checkinsCount']

      # ap place['name'] + ' | ' + place['stats']['checkinsCount'].to_s
    end

    ap no_match_count.to_s + ' / ' + results['venues'].count.to_s
    ap Hash[venues.sort_by{|k, v| v}.reverse]
  end
end


private

# get tips from foursquare
# tips = client.venue_tips(id, {limit: 500})
def tips_to_word_map(tips)
  tgr = EngTagger.new
  sentence_cluster = []
  ap tips['items'].count.to_s + ' tips imported...'
  tips['items'].each do |t|
    sentence_cluster << normalize(t.text)
  end

  tagged = tgr.add_tags(sentence_cluster.join(' . '))
  nouns = tgr.get_nouns(tagged)
  adjectives = tgr.get_adjectives(tagged)

  ap Hash[nouns.sort_by{|k, v| v}.reverse].first(5)
  ap Hash[adjectives.sort_by{|k, v| v}.reverse].first(5)
end

def client
  Foursquare2::Client.new(:client_id => 'TJRRETTNS1GOAYUAM2J3UWPANIOGJHALV4AAWGNWCAMIQYVV',
                          :client_secret => '2RPAZSAJZ3QVSF3QX224FIVW5AW2FDFWSSAV1IS5PWBDVA0H',
                          :api_version => '20150806')
end

def normalize(s)
  # remove symbols
  s.gsub!('!', '')
  s.gsub!('?', '')
  s.gsub!('/', ' ')
  s.gsub!('-', ' ')
  s.gsub!('.', '')

  # singularize
  singularized = []
  s.split(' ').each do |word|
    word = word.singularize
    singularized << word
  end

  s = singularized.join(' ')

  return s.downcase
end