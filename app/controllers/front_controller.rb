class FrontController < ApplicationController

  # Any time new message is sent from Front, webhook passes event data to this endpoint
  def mirror
    ap "NUMBER: #{params['message']['conversation']['recipient']['handle']}"
    ap "DATE: #{Time.at(params['message']['date']/1000)}"
    ap "INBOUND: #{params['message']['inbound']}"
    ap "TYPE: #{params['message']['type']}"
    ap "TEXT: #{params['message']['text']}"
  end
end