source 'http://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.0'

# Use postgres as the database for Active Record
gem 'pg'


#AJAX CORS
gem 'rack-cors', :require => 'rack/cors'

# for storing prices
gem 'money-rails', github: "RubyMoney/money-rails"
gem 'monetize', github: "RubyMoney/monetize"

# Identity / Sign-in
gem 'omniauth'
gem 'omniauth-facebook'
gem 'bcrypt-ruby', '3.1.2'

#Image upload
gem 'paperclip', '4.0' #, '~> 3.0'
gem 'aws-sdk', '~> 1.5.7'
#Delayed jobs (image upload)
gem "resque", :require => 'resque/server'  
gem 'delayed_paperclip'
gem "capistrano-resque", github: "sshingler/capistrano-resque", require: false

#scheduled rake tasks
gem 'whenever', :require => false

#product_source qc page
gem 'imgkit'

#rss feed reader
gem 'feedjira'


# Admin Backend
gem 'activeadmin', github: 'gregbell/active_admin'

# Audit ActiveAdmin using Paper Trail
gem 'paper_trail'

# full-text search with elasticsearch
gem 'tire'

# soft-delete for AR models
gem 'paranoia', '~> 2.0'

# View-related
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'haml-rails', github: 'indirect/haml-rails'
gem 'jquery-rails', github: 'rails/jquery-rails'
gem 'jquery-ui-rails', github: 'joliss/jquery-ui-rails'
gem 'susy'
gem 'compass', '>= 0.12.2'
gem 'compass-rails', '~> 1.1'


# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'
gem 'active_model_serializers'

# Used for XML Builder in API
gem 'nokogiri'

# For API documentation
gem 'swagger-docs'
gem 'apipie-rails'

# high-performance HTTP lib (for checking product source status)
gem 'typhoeus'

# for performance monitoring in prod
gem 'newrelic_rpm'

group :development do
  gem 'thin'

  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'letter_opener'
  
  gem 'pry-rails'
  gem 'pry-debugger'
  gem 'awesome_print'

  gem 'quiet_assets'

  gem 'annotate'
  gem 'rails-erd'
  gem 'rack-mini-profiler'
  gem "bullet"
end

gem "rspec-rails", :group => [:test, :development]
group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
  gem 'shoulda-matchers'
  gem 'cucumber-rails', '1.4.1', :require => false
  gem 'selenium-webdriver', '2.42.0'
  gem "capybara-webkit" # for runing javasript test without opening a browser
  gem 'launchy'
  gem 'spork-rails' # Run rspec faster 
  gem 'database_cleaner' # remove data test
  gem 'email_spec' # for testing email
  gem "action_mailer_cache_delivery" # for testing emails with Selenium
  gem 'faker'  # generates fake data
  gem "method_source" # to view method source code, example: ActiveRecord::Base.instance_method(:destroy).source.display
  gem 'simplecov', '0.7.1', require: false
end


group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# rubber (& associated gems) used for managing deployment to AWS
gem 'rubber'
gem 'open4'
gem 'gelf', git: 'https://github.com/jridgway/gelf-rb.git'
gem 'graylog2_exceptions', git: 'git://github.com/wr0ngway/graylog2_exceptions.git'
gem 'graylog2-resque'
gem 'unf' 

# for catching exceptions and creating GH issues
gem 'party_foul'

# font-awesome for icons
gem 'font-awesome-rails', github: 'bokmann/font-awesome-rails'
gem 'font-awesome-sass', github: 'FortAwesome/font-awesome-sass'
