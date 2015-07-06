class MoviesController < ApplicationController

	before_action :set_main_menu
	before_action :categories
	before_action :set_movie

	PER_PAGE = 15

	def show
		if params[:product_page].blank? & params[:outfit_page].blank?
			@products = @movie.products.active.uniq.includes(:brand, :characters, :product_categories, :outfits => :movie).limit(PER_PAGE)
			@outfits = @movie.outfits.approved.uniq.includes(:character).limit(PER_PAGE)

			params[:product_page] = @products.length == PER_PAGE ? 1 : -1
			params[:outfit_page] = @outfits.length == PER_PAGE ? 1 : -1

			@characters = @movie.characters.active
		else
			if params[:product_page].present?
				@products = @movie.products.active.uniq.includes(:brand, :characters, :product_categories, :outfits => :movie).offset(params[:product_page].to_i * PER_PAGE).limit(PER_PAGE)
				params[:product_page] = @products.length == PER_PAGE ? params[:product_page].to_i + 1 : -1
			else
				@outfits = @movie.outfits.approved.uniq.includes(:character).offset(params[:outfit_page].to_i * PER_PAGE).limit(PER_PAGE)
				params[:outfit_page] = @outfits.length == PER_PAGE ? params[:outfit_page].to_i + 1 : -1
			end
		end
		
	end


	private

	def set_movie
		@movie = Movie.find(params[:id])
	end

	# def authenticate_if_exclusive
 #    if [5].include? @movie.id
 #      authenticate_or_request_with_http_basic 'Staging' do |name, password|
 #        (name == 'staging_user' && password == 'spylight_confidential') || (name == "jay" && password == "levine")
 #      end
 #    end
 #  end

end
