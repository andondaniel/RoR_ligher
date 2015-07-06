# == Schema Information
#
# Table name: searches
#
#  searchable_id   :integer
#  searchable_type :text
#  term            :string
#

class Search < ActiveRecord::Base
  attr_accessor :query

  def results
    if @query.present?
      shows = Show.tire.search(@query, load: true, per_page: 100).results
      episodes = Episode.tire.search(@query, load: true, per_page: 100).results
      characters = Character.tire.search(@query, load: true, per_page: 100).results
      categories = ProductCategory.tire.search(@query, load: true, per_page: 100).results
      products = Product.tire.search(@query, load: true, per_page: 100).results
      return {characters: characters, categories: categories,
              shows: shows, episodes: episodes, products: products}
    else
      Search.none
    end
  end

  def api_shows
    if @query.present?
      shows = Show.tire.search(@query, load: true, per_page: 100).results
    else
      Search.none
    end
  end

  def api_episodes
    if @query.present?
      episodes = Episode.tire.search(@query, load: true, per_page: 100).results
    else
      Search.none
    end
  end

  def api_characters
    if @query.present?
      characters = Character.tire.search(@query, load: true, per_page: 100).results
    else
      Search.none
    end
  end

  def api_categories
    if @query.present?
      categories = ProductCategory.tire.search(@query, load: true, per_page: 100).results
    else
      Search.none
    end
  end

  def api_products
    if @query.present?
      products = Product.tire.search(@query, load: true, per_page: 100).results
    else
      Search.none
    end
  end
  
end
