class OutfitsController < ApplicationController

	def show
    @outfit = Outfit.find_by(id: params[:id])
    @character = @outfit.character
    
    # the following IF statements are if the outfit belongs to TV:
    @show = Show.find_by(id: params[:show_id]) if :show_id
    @movie = Movie.find_by(id: params[:movie_id]) if :movie_id
    @episode = @outfit.episodes.first if @outfit.episodes.any?
    
    if @episode
      @episodenumber = @episode.episode_number
      @season = @outfit.episodes.first.season
    end

    respond_to do |format|
      format.js
      format.html
    end
  end

  def index
    @json_outfits = Outfit.order('slug').finder(params[:q]).page(params[:page]).per(params[:per])
      respond_to do |format|
        format.json { render json: @json_outfits }
      end
  end


end
