namespace :foursq do
  desc 'Dumps the production database on heroku to db/ferris.dump'
  task :pull => :environment do
    client = Foursquare2::Client.new(:client_id => 'TJRRETTNS1GOAYUAM2J3UWPANIOGJHALV4AAWGNWCAMIQYVV',
                                     :client_secret => '2RPAZSAJZ3QVSF3QX224FIVW5AW2FDFWSSAV1IS5PWBDVA0H',
                                     :api_version => '20150806')
    ap client.search_venues({near: 'Boston, MA', section: 'drinks', offset:'5', limit:'5'})
  end
end