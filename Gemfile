source 'https://rubygems.org'

gem 'rails', '3.2.13'

# Database
gem 'pg'
gem "foreigner"

# I18n
gem 'rails-i18n'

# Improvements
gem 'inherited_resources'
#gem 'has_scope'

# Authentication
gem "devise", "~> 2.1.2"
gem "omniauth", "~> 1.1.0"
gem "omniauth-facebook", "~> 1.2.0"
gem "omniauth-twitter", "~> 0.0.12"
gem "cancan"

# Server
gem 'thin'
gem 'capistrano'

# Frontend stuff
gem 'jquery-rails'
gem "slim"
gem "slim-rails"
gem 'initjs'
gem 'rack-google-analytics'

# Tools
gem 'simple_form'
gem 'carrierwave'
gem "fog", "~> 1.3.1"
gem "rmagick"
gem "rails-settings-cached"

# Administration
gem 'rails_admin'
#gem 'activeadmin'

# Payment
gem 'moiper'

group :assets do
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'
  gem "compass-rails", "~> 1.0.3"
  gem 'bootstrap-sass'
  gem 'uglifier', '>= 1.0.3'
  #gem 'turbolinks'
end

group :production do
  gem "execjs"
  gem 'therubyracer', platform: :ruby
end

group :development, :test do
  gem "rspec-rails", ">= 2.11.0"
  gem "shoulda-matchers"
  gem "machinist", ">= 2.0"
  gem "ffaker"
  gem 'database_cleaner'
  gem "capybara"
  gem "launchy"
  gem "jasmine"
  gem "pry"
  gem 'awesome_print'
end

group :development do
  gem 'zeus'
end
