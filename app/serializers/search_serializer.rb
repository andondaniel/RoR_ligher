class SearchSerializer < ActiveModel::Serializer
	delegate :params, to: :scope
  attributes :shows, :episodes, :characters, :categories, :products

  def shows
  	object.api_shows.map { |s| ShowSerializer.new(s) }
  end

  def episodes
  	object.api_episodes.map { |e| EpisodeSerializer.new(e) }
  end

  def characters
  	object.api_characters.map { |c| CharacterSerializer.new(c) }
  end

  def categories
  	object.api_categories
  end

  def products
  	object.api_products.map { |p| ProductSerializer.new(p) }
  end

  def attributes
    data = super
    if params[:quantity]
    	quantity = params[:quantity].to_i
    else
    	quantity = 10
    end

    #remove empty results
    data.delete_if {|key, value| value == [] }

    #remove results based on param requests
    data.delete(:shows) if(params[:shows] == "false")
    data.delete(:episodes) if(params[:episodes] == "false")
    data.delete(:categories) if(params[:categories] == "false")
    data.delete(:characters) if(params[:characters] == "false")
    data.delete(:products) if(params[:products] == "false")

    #limit quantites of results based on params
    unless quantity == 0
	    data.each_pair do |key, value|
	    	data[key] = value.first(quantity)
	    end
	  end

    return data
  end

end
