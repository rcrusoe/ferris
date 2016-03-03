source 'https://rubygems.org'

# specify ruby version for Heroku
ruby '2.2.3'

# webserver for Heroku
gem 'puma'

# postgreSQL
gem 'pg'

# authentication
gem 'devise'

gem 'rails',                '4.2.2'
gem 'sass-rails',           '5.0.2'
gem 'uglifier',             '2.5.3'
gem 'coffee-rails',         '4.1.0'
gem 'jquery-rails',         '4.0.3'
gem 'turbolinks',           '2.3.0'
gem 'jbuilder',             '2.2.3'
gem 'sdoc',                 '0.4.0', group: :doc
gem 'semantic-ui-sass'
gem 'paperclip', '~> 4.3'
gem 'aws-sdk', '< 2.0'
gem 'twilio-ruby', '~> 4.2.1'

# formatted printing from rails console
gem 'awesome_print', require:'ap'

# http requests made easy
gem 'rest-client'

# page specific javascript execution
gem 'paloma'

# group activerecord queries by date
gem 'groupdate'

# one line charting
# http://ankane.github.io/chartkick/

group :development, :test do
  gem 'byebug',      '3.4.0'
  # gem 'better_errors'
  gem 'web-console', '2.0.0.beta3'
  gem 'spring',      '1.1.3'
  gem 'rspec-rails',      '>= 2.0.0.beta'
  gem 'capybara'
  gem 'quiet_assets'
end

group :production do

  gem 'rails_12factor', '0.0.2'
end