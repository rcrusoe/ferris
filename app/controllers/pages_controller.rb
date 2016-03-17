class PagesController < ApplicationController
  def home
  end

  def rec
    js :URL => request.base_url
  end
end
