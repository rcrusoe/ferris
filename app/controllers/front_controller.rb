class FrontController < ApplicationController

  # Any time new message is sent from Front, webhook passes event data to this endpoint
  def mirror
    logger.debug 'PARAMS: ' + params
    ap params
  end
end