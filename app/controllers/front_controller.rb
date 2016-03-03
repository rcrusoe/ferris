class FrontController < ApplicationController

  # Any time new message is sent from Front, webhook passes event data to this endpoint
  def mirror
    data = JSON.parse(params)
    ap data
  end
end