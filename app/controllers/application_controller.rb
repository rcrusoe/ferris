class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  # events page is internal
  def authenticate
    if Rails.env.production?
      authenticate_or_request_with_http_basic('Events archive is private.') do |username, password|
        username == 'ferris' && password == 'boston'
      end
    end
  end
end
