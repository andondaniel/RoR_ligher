class SearchController < ApplicationController

	def index
		@query = params[:search]
		@results = Search.new(query: @query).results.delete_if {|type, result| (result.length == 0) || (type == :categories) }
		# is there a way to do the above within the Search model?

		@products = @results.fetch(:products, []).select(&:active).uniq
		@shows = @results.fetch(:shows, []).select(&:active)
		@characters = @results.fetch(:characters,[]).select(&:active)
		# @episodes = @results.fetch(:episodes, []).select{|e| e.show.approved}
		# Why doesn't the above work? below is the temp code for now.
		@episodes = @results.fetch(:episodes,[]).select{|e| e.show.present? && e.name.present? && e.episode_images.any?}

		# eg PRODUCT CATEGORIES, PRODUCTS, SHOWS...
		@result_type = @results.keys.map(&:to_s)


	  # BELOW: for the product filter
			# List of Product Categories
		  categories = @products.map{|product| product.product_categories}.flatten.compact.map(&:name)

		  # Counting how many of each category there are.
		  count = Hash.new(0)
			categories.each{ |category| count[category] += 1}
		  @categorycount = count.to_a	  

		  #Counting how many of each gender there are:
	    genders = @products.map{|p| p.characters.any? ? p.characters.first.gender : nil}.compact
	    @gendercount = genders.group_by{|g| g}.map{|gender, product| [gender, product.size]}

		  #Characters
		  characters = @products.map{|product| product.characters}.flatten.compact
		  @charactercount = characters.group_by(&:name).map{|character, product| [character, product.size]}
	  
	end

end
