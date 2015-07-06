class EpisodesController < ApplicationController
  before_action :set_episode, only: [:show]
  before_action :set_main_menu
  before_action :categories

  # GET /episodes
  # GET /episodes.json

  PER_PAGE = 15

  def index

    @show_episodes = @show.episodes.active
    @sorted_episodes = @show_episodes.sort_by(&:airdate).reverse

    if @sorted_episodes.any?
      redirect_to show_episode_path(show_id: @show.slug, id: @sorted_episodes.first.slug)
    else
      redirect_to show_episode_path(show_id: @show.slug, id: @show.episodes.last.slug)
    end

  end

  def seasons
    @season = params[:season]
    @show = Show.find(params[:show_id])
    @episodes = @show.episodes.active.where(season: params[:season])
    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /episodes/1
  # GET /episodes/1.json
  def show

    # If episodes page showes firstly, it should need to get all information of filter.
    if params[:product_page].blank? & params[:outfit_page].blank?
      @products = @episode.products.active.uniq
      @characters = @episode.characters.active
      @outfits = @episode.outfits.includes([:outfit_products, :episodes]).active.uniq

      @episodes = @show.episodes.active.includes(:episode_images).where(season: @episode.season).sort_by(&:airdate).reverse
      
      # choose the episode's active characters that have been assigned importances and sort by importance.
      @characters = @episode.outfits.includes(:character).active.uniq.map{|x| x.character}.uniq.select{|x| x.active?}.select{|ch, o| ch.importance}.sort_by{|ch| ch.importance}

      # The following is for the .item-preview

        # Only select characters with exact matches for that particular episode and sort them by importance
        @characters_with_exact_matches = @episode.outfits.includes({:outfit_products => [:product, {:outfit => :character}]}).active.uniq.map{|x| x.outfit_products}.flatten.uniq.select{|op| op.exact_match? && op.product && op.active? }.flatten.group_by{|op| op.outfit.character}.select{|ch, o| ch.importance}.sort_by{|ch, o| ch.importance}.take(3)
        

        # TODO: Think about what happens if there are no exact matches in an episode. 
        # ANSWER: Well, I made it so that verified episodes MUST have at least one exact match.

      # show products that are active outfit_products; make sure there are no repeats
      @products = @episode.products.includes(:brand).active.uniq

      # The episodes that available outfits appear in
      @outfitepisodes = @outfits.map(&:episodes).flatten.select(&:active?).uniq

      # Counting how many of each category there are.
      categories = @products.includes(:product_categories).map{|p| p.product_categories}.flatten.compact.map(&:name)
      count = Hash.new(0)
      categories.each{ |category| count[category] += 1 }
      @categorycount = count.to_a

      #Counting how many of each gender there are:
      genders = @products.map{|p| p.gender}
      @gendercount = genders.group_by{|g| g}.map{|gender, product| [gender, product.size]}

      #Characters: counts how many of each character there are
      characters = @products.includes(:characters).map{|p| p.characters}.flatten.compact
      @charactercount = characters.group_by(&:name).map{|character, product| [character, product.size]}
      
      @filter = params[:filter]

      @products = @products.slice(0, PER_PAGE).compact
      @outfits = @outfits.slice(0, PER_PAGE).compact

      params[:product_page] = @products.length == PER_PAGE ? 1 : -1
      params[:outfit_page] = @outfits.length == PER_PAGE ? 1 : -1

    else
      if params[:product_page].present?
        @products = @episode.products.includes(:brand).active.uniq.offset(params[:product_page].to_i * PER_PAGE).limit(PER_PAGE)
        params[:product_page] = @products.length == PER_PAGE ? params[:product_page].to_i + 1 : -1
      else
        @outfits = @episode.outfits.includes([:outfit_products, :episodes]).active.uniq.offset(params[:outfit_page].to_i * PER_PAGE).limit(PER_PAGE)
        params[:outfit_page] = @outfits.length == PER_PAGE ? params[:outfit_page].to_i + 1 : -1
      end
    end

    respond_to do |format|
      format.html
      format.js
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find_by_slug(params[:id])
      @show = @episode.show
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:season, :episode_number, :name, :airdate, :show_id)
    end

  # def authenticate_if_exclusive
  #   if [37, 35, 32, 30, 27].include? @show.id
  #     authenticate_or_request_with_http_basic 'Staging' do |name, password|
  #       (name == 'staging_user' && password == 'spylight_confidential') || (name == "jay" && password == "levine")
  #     end
  #   end
  # end
end