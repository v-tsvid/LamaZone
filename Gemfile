source 'https://rubygems.org'
ruby "2.2.2"


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '0.18.2'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.7.1'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.0.4'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '3.1.10'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'cancancan', '1.13.1'
gem 'countries', '0.11.5', :require => 'iso3166'
gem 'phony_rails', '0.12.9'
gem 'validates_zipcode', '0.0.6'
gem 'credit_card_validator', '1.2.0'
gem 'validates_timeliness', '3.0.14'
gem 'rails_admin', '0.6.8'
gem 'carrierwave', '0.10.0', github:'carrierwaveuploader/carrierwave'
gem 'mini_magick', '4.2.9'
gem 'devise', '3.5.1'
gem 'fog-aws', '0.7.4'
gem 'bootstrap-sass', '3.3.5.1'
gem 'haml', '4.0.6'
gem 'omniauth-facebook', '2.0.1'
gem 'aasm', '4.2.0'
gem 'simplecov', '0.10.0', :require => false, :group => :test
gem 'rspec-activemodel-mocks', '1.0.2'
gem 'rspec-rails', '3.3.2'
gem 'faker', '1.4.3'
gem 'factory_girl_rails', '4.5.0'
gem 'bootstrap-slider-rails', '6.1.4'
gem 'kaminari', '0.16.3'
gem 'wicked', '1.2.1'
gem 'reform', '2.1.0'
gem 'reform-rails', '0.1.0'
gem 'routing-filter', '0.5.1'
gem "rubycritic", '2.9.1', :require => false
gem 'draper', '2.1.0'
gem 'jquery-star-rating-rails', '4.0.4'
gem 'cloudinary', '1.2.2'
  
  
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'capybara', '2.4.4'
  gem 'capybara-webkit', '1.6.0'
  gem 'launchy', '2.4.3'
end

group :test do
  gem 'database_cleaner', '1.4.1'
  gem 'shoulda-matchers', '3.1.1'
  gem 'shoulda-callback-matchers'
  gem "codeclimate-test-reporter", '0.4.8', require: nil
end

group :production do
  gem 'rails_12factor', '0.0.3'
  # gem 'unicorn', '5.1.0'
  # gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
  # gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
end
