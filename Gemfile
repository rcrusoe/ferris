source 'https://rubygems.org'

# ============================================
# General
# ============================================
ruby '2.2.3'
gem 'rails',                '4.2.2'
gem 'puma'
gem 'pg'

# authentication
gem 'devise'

# S3 bucket for images
gem 'paperclip',            '~> 4.3'
gem 'aws-sdk',              '< 2.0'

# SMS
gem 'twilio-ruby',          '~> 4.2.1'

# ============================================
# Front End
# ============================================
gem 'uglifier',             '>= 2.5.3'
gem 'sass-rails',           '~> 5.0.2'
gem 'coffee-rails',         '4.1.0'
gem 'jquery-rails',         '4.0.3'
gem 'turbolinks',           '2.3.0'
# gem 'jquery-turbolinks'
# gem 'jbuilder',             '2.2.3'

gem 'semantic-ui-sass'
# TODO: install lodash

# page specific javascript execution
gem 'paloma'

# ============================================
# Utility
# ============================================

# JSON serialization
gem 'active_model_serializers', '0.9.0'

# http requests made easy
gem 'rest-client'

# date related
gem 'groupdate'
gem 'ice_cube'
gem 'recurring_select'

# better forms
gem 'simple_form'
gem 'cocoon'

# one line charting
# http://ankane.github.io/chartkick/

# Location
gem 'geocoder'

# ============================================
# Debug
# ============================================

# formatted printing from rails console
gem 'awesome_print', require:'ap'

group :development, :test do
  # gem 'better_errors'
  gem 'byebug'
  gem 'pry-rails'
  gem 'web-console'
  gem 'spring'
  gem 'rspec-rails',      '>= 2.0.0.beta'
  gem 'capybara'
  gem 'quiet_assets'
  gem 'ruby-prof'
  gem 'meta_request' # rails console in chrome
  gem 'bullet'
end

group :production do
  gem 'rails_12factor'
end