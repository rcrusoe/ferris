class Foursquare


  private

  def client
    Foursquare2::Client.new(:client_id => 'TJRRETTNS1GOAYUAM2J3UWPANIOGJHALV4AAWGNWCAMIQYVV',
                            :client_secret => '2RPAZSAJZ3QVSF3QX224FIVW5AW2FDFWSSAV1IS5PWBDVA0H',
                            :api_version => '20160301')
  end
end