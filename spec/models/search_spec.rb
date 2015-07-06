require 'spec_helper'

describe Search do
  let(:query) { "test" }

  before :all do
    if Show.count < 1
      FactoryGirl.create(Show, name: "test #{Faker::Name.name}")
      FactoryGirl.create(Episode, name: "test #{Faker::Name.name}")
      FactoryGirl.create(Character, name: "test #{Faker::Name.name}")
      FactoryGirl.create(ProductCategory, name: "test #{Faker::Name.name}")
      FactoryGirl.create(Product, name: "test #{Faker::Name.name}")
      reindex #spec/support/helper.rb
    end
  end

  describe ".results" do
    it "query is present" do
      binding.pry
      search = Search.new(query: query)
      search.results.count.should == 5
      search.results[:characters].first.name.should == query
      search.results[:categories].first.name.should == query
      search.results[:shows].first.name.should == query
      search.results[:episodes].first.name.should == query
    end

    it "query is nil" do
      search = Search.new
      search.results.count.should == 0
    end
  end

  describe ".api_shows" do
    it "query is present" do
      search = Search.new(query: query)
      search.api_shows.count.should == 1
      search.api_shows.first.name == query
    end

    it "query is nil" do
      search = Search.new
      search.api_shows.count.should == 0
    end
  end

  describe ".api_episodes" do
    it "query is present" do
      search = Search.new(query: query)
      search.api_episodes.count.should == 1
      search.api_episodes.first.name == query
    end

    it "query is nil" do
      search = Search.new
      search.api_episodes.count.should == 0
    end
  end

  describe ".api_characters" do
    it "query is present" do
      search = Search.new(query: query)
      search.api_characters.count.should == 1
      search.api_characters.first.name == query
    end

    it "query is nil" do
      search = Search.new
      search.api_characters.count.should == 0
    end
  end


  describe ".api_categories" do
    it "query is present" do
      search = Search.new(query: query)
      search.api_categories.count.should == 1
      search.api_categories.first.name == query
    end

    it "query is nil" do
      search = Search.new
      search.api_categories.count.should == 0
    end
  end

  describe ".api_products" do
    it "query is present" do
      search = Search.new(query: query)
      search.api_products.count.should == 2
      search.api_products.first.name == query
    end

    it "query is nil" do
      search = Search.new
      search.api_products.count.should == 0
    end
  end

end