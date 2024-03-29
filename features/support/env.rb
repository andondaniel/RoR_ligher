require 'rubygems'
require 'spork'

require 'simplecov'
SimpleCov.coverage_dir 'coverage/cucumber'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'
  add_filter 'app/models'
  add_filter 'app/helpers'
  add_filter 'app/mailers'
  add_filter 'features/step_definitions'
  add_filter 'factories/'
end



class Seed

  def self.reindex
      Show.tire.index.delete
      Show.create_elasticsearch_index
      Show.all.each do |s|
        s.tire.update_index
      end
      Show.tire.index.refresh

      Episode.tire.index.delete
      Episode.create_elasticsearch_index
      Episode.all.each do |s|
        s.tire.update_index
      end
      Episode.tire.index.refresh

      Character.tire.index.delete
      Character.create_elasticsearch_index
      Character.all.each do |s|
        s.tire.update_index
      end
      Character.tire.index.refresh

      ProductCategory.tire.index.delete
      ProductCategory.create_elasticsearch_index
      ProductCategory.all.each do |s|
        s.tire.update_index
      end
      ProductCategory.tire.index.refresh

      Product.tire.index.delete
      Product.create_elasticsearch_index
      Product.all.each do |s|
        s.tire.update_index
      end
      Product.tire.index.refresh
  end


  def self.load_seed
    if Outfit.count < 2
      puts "Load seed..."
      unless User.exists?(email: 'khanh@gmail.com')
        FactoryGirl.create(:user, email: 'khanh@gmail.com')
      end

      Show.skip_callback(:create, :after, :save, :update_verification)
      Movie.skip_callback(:create, :after, :save, :update_verification)
      show = FactoryGirl.create(:show, name: Faker::Name.name)
      show.update_column(:verified, true)

      outfit = FactoryGirl.create(:outfit_with_active_product, featured: true)
      scene = FactoryGirl.create(:scene, show: show, outfits: [outfit])
      episode = FactoryGirl.build(:episode, season: Faker::Number.number(1), episode_number: Faker::Number.number(2),
                                  name: Faker::Name.name, airdate: Time.now - 1.day)
      episode.show = show
      episode.scenes = [scene]
      episode.save!

      movie = FactoryGirl.create(:movie)
      movie.update_column(:verified, true)

      FactoryGirl.create(:character)
      brand = FactoryGirl.create(:brand)
      product_source = FactoryGirl.create(:product_source)
      product_category = FactoryGirl.create(:product_category)
      product_set = FactoryGirl.create(:product_set)

      [271, 1021, 827, 768, 6492, 1798, 6496, 6506, 1776, 1775, 1268, 1164, 3858].each do |id|
        product = FactoryGirl.build(:product, name: Faker::Name.name, description: Faker::Lorem.paragraph, id: id)
        product.brand = brand
        product.product_sources = [product_source]
        product.product_categories = [product_category]
        product.product_set = product_set
        product.save!
      end

      FactoryGirl.create(:character, featured: true, show: show)
      Seed.reindex
    end

    def self.init_user_data
      FactoryGirl.create(:user, email: 'bob@bob.bob', password: '123', password_confirmation: '123') unless User.exists?(email: 'bob@bob.bob')
      FactoryGirl.create(:user, email: 'john@john.john', password: '123', password_confirmation: '123', admin: true, role: "Admin") unless User.exists?(email: 'john@john.john')
    end
  end
end
# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

Spork.prefork do

  ENV['RAILS_ENV'] = 'development'

  require 'cucumber/rails'
  require 'email_spec' # add this line if you use spork
  require 'email_spec/cucumber'
  require 'factory_girl'
  Dir[Rails.root.join("factories/*.rb")].each { |f| require f }
  require 'capybara/rspec'


  if defined? Bullet
    Bullet.bullet_logger = false
    Bullet.enable = false
    Bullet.alert = false
    Bullet.bullet_logger = false
    Bullet.console = false
  end


  Before do
    Capybara.default_host = 'http://localhost:3000'
  end

  # Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
  # order to ease the transition to Capybara we set the default here. If you'd
  # prefer to use XPath just remove this line and adjust any selectors in your
  # steps to use the XPath syntax.
  Capybara.default_selector = :css
  #Capybara.run_server = true #Whether start server when testing
  Capybara.server_port = Rails.application.routes.default_url_options[:port]
  #Capybara.default_wait_time = 5 #When we testing AJAX, we can set a default wait time
  Capybara.ignore_hidden_elements = false #Ignore hidden elements when testing, make helpful when you hide or show elements using javascript
  Capybara.javascript_driver = :selenium #default driver when you using @javascript tag

  # Remove/comment out the lines below if your app doesn't have a database.
  # For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
  begin
    DatabaseCleaner.strategy = :transaction #transaction
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end
  ActionController::Base.allow_rescue = false
  Cucumber::Rails::Database.javascript_strategy = :transaction

  # init_user_data
  FactoryGirl.create(:user, email: 'bob@bob.bob', password: '123', password_confirmation: '123') unless User.exists?(email: 'bob@bob.bob')
  FactoryGirl.create(:user, email: 'john@john.john', password: '123', password_confirmation: '123', admin: true, role: "Admin") unless User.exists?(email: 'john@john.john')

  # Seed.load_seed
end

Spork.each_run do
  # By default, any exception happening in your Rails application will bubble up
  # to Cucumber so that your scenario will fail. This is a different from how
  # your application behaves in the production environment, where an error page will
  # be rendered instead.
  #
  # Sometimes we want to override this default behaviour and allow Rails to rescue
  # exceptions and display an error page (just like when the app is running in production).
  # Typical scenarios where you want to do this is when you test your error pages.
  # There are two ways to allow Rails to rescue exceptions:
  #
  # 1) Tag your scenario (or feature) with @allow-rescue
  #
  # 2) Set the value below to true. Beware that doing this globally is not
  # recommended as it will mask a lot of errors for you!
  #
  #ActionController::Base.allow_rescue = false

  # Remove/comment out the lines below if your app doesn't have a database.
  # For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
  #begin
  #  DatabaseCleaner.strategy = :truncation #transaction
  #rescue NameError
  #  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  #end

  # You may also want to configure DatabaseCleaner to use different strategies for certain features and scenarios.
  # See the DatabaseCleaner documentation for details. Example:
  #

  #Before('@no-txn,@selenium,@culerity,@celerity,@javascript') do
  #  # { :except => [:widgets] } may not do what you expect here
  #  # as tCucumber::Rails::Database.javascript_strategy overrides
  #  # this setting.
  #  DatabaseCleaner.strategy = :truncation
  #end
  #
  #Before('~@no-txn', '~@selenium', '~@culerity', '~@celerity', '~@javascript') do
  #  DatabaseCleaner.strategy = :transaction
  #end
  #

  # Possible values are :truncation and :transaction
  # The :transaction strategy is faster, but might give you threading problems.
  # See https://github.com/cucumber/cucumber-rails/blob/master/features/choose_javascript_database_strategy.feature
  #Cucumber::Rails::Database.javascript_strategy = :truncation

end