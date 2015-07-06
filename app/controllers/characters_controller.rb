
class CharactersController < ApplicationController

  before_action :set_main_menu
  before_action :set_characters
  before_action :set_character, only: [:show]
  before_action :categories

  PER_PAGE = 15
  # GET /characters
  # GET /characters.json
  def index
    redirect_to show_character_path(show: @show, id: @characters.first)
  end

  # GET /characters/1
  # GET /characters/1.json
  def show

    # If characters page showes firstly, it should need to get all information of filter.
    if params[:product_page].blank? & params[:outfit_page].blank?
      if @character
        @products = @character.products.active.uniq
        @outfits = @character.outfits.active.uniq
      end

      @character_description = @character.description

      # BELOW: for the product filter
      if @products
        categories = @products.includes(:product_categories).map{|product| product.product_categories}.flatten.compact.map(&:name)

        # The episodes that available outfits appear in
        @outfitepisodes = @outfits.includes(:episodes).map(&:episodes).flatten.select(&:active?).uniq.sort_by(&:airdate).reverse


        # Counting how many of each category there are.
        count = Hash.new(0)
        categories.each{ |category| count[category] += 1 }
        @categorycount = count.to_a

        #Counting how many of each gender there are:
        genders = @products.map{|p| p.characters.first.gender}
        @gendercount = genders.group_by{|g| g}.map{|gender, product| [gender, product.size]}

        #Characters
        characters = @products.includes(:characters).map{|product| product.characters}.flatten.compact
        @charactercount = characters.group_by(&:name).map{|character, product| [character, product.size]}
      end
    end

    if @character
      if params[:product_page].blank? & params[:outfit_page].blank?
        @products_count = @character.products.active.uniq.length
        @products = @character.products.active.uniq.includes(:brand).limit(PER_PAGE)

        @outfits_count = @character.outfits.active.uniq.length
        @outfits = @character.outfits.active.uniq.limit(PER_PAGE)

        params[:product_page] = @products.length == PER_PAGE ? 1 : -1
        params[:outfit_page] = @outfits.length == PER_PAGE ? 1 : -1
      else
        if params[:product_page].present?
          @products = @character.products.active.uniq.includes(:brand).offset(params[:product_page].to_i * PER_PAGE).limit(PER_PAGE)
          params[:product_page] = @products.length == PER_PAGE ? params[:product_page].to_i + 1 : -1
        else
          @outfits = @character.outfits.active.uniq.offset(params[:outfit_page].to_i * PER_PAGE).limit(PER_PAGE)
          params[:outfit_page] = @outfits.length == PER_PAGE ? params[:outfit_page].to_i + 1 : -1
        end
      end

      character_slug = @character.slug
      @actor = @character.actor
    end

    respond_to do |format|
      format.html
      format.js
    end

  end 


  private


  # def set_main_menu
  #   @networks = Network.all.select{|x| x.shows.active.any?}
  #   @movies = Movie.all.approved

  #   @firstnetwork = @show.network
  #   @firstshow = @show
  # end

  def set_characters
    @characters = @show.characters.approved.select{|ch| ch.importance}.sort_by{|ch| ch.importance}
  end

  def set_character
    @character = Character.find_by_slug(params[:id])
    @show = @character.show
  end

  # def authenticate_if_exclusive
  #   if @show
  #     if [37, 35, 32, 30, 27].include? @show.id
  #       authenticate_or_request_with_http_basic 'Staging' do |name, password|
  #         (name == 'staging_user' && password == 'spylight_confidential') || (name == "jay" && password == "levine")
  #       end
  #     end
  #   end
  # end

end