class API::V1::OutfitsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json
  before_action :set_outfit, only: [:show, :update, :destroy]
  # before_action :default_serializer_options

  resource_description do
    short "Outfits seen on supported shows"
    description ""
    formats ['json']
  end

  # GET /shows
  # GET /shows.json
  api :GET, "/v1/outfits", "Lists all outfits"
  api :GET, "v1/shows/:show_slug/outifts", "Lists all outfits for a given show"
  api :GET, "v1/movies/:movie_slug/outifts", "Lists all outfits for a given movie"
  api :GET, "/v1/shows/:show_slug/characters/:character_slug/outfits", "Lists all outfits for a given character"
  api :GET, "/v1/movies/:movie_slug/characters/:character_slug/outfits", "Lists all outfits for a given character"
  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/outfits", "Lists all outfits for a given episode"
  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id/outfits", "Lists all outfits for a given scene"
  api :GET, "/v1/movies/:movie_slug/scenes/:scene_id/outfits", "Lists all outfits for a given scene"
  description "Returns outfits, each of which contains a number of products."
  param :cache_update, Integer, desc: "takes an integer value and returns all outfits with an greater than that value. Used for finding all new outfits since last cache update. Note: If you enter a value for cache update all other params are ignored."
  param :active, [true, false], desc: "boolean marker that when set to true only returns active objects"
  param :per_page, Integer, desc: "if given it will paginate the results of the query"
  param :page, Integer, desc: "if pagination is enabled, page will specify which range of data will be returned"
  param :no_embed, [true, false], desc: "if set to true, products will not be embeded in the JSON response. Defaults to false."
  def index
    if params[:cache_update]
      @outfits = Outfit.where("id > ?", params[:cache_update])
    elsif params[:show_id]
      @show = Show.find_by_slug(params[:show_id])
      if params[:character_id]
        @character = @show.characters.find_by_slug(params[:character_id])
        @outfits = @character.outfits
      elsif params[:episode_id]
        @episode = @show.episodes.find_by_slug(params[:episode_id])
        if params[:scene_id]
          @scene = @episode.scenes.find(params[:scene_id])
          @outfits = @scene.outfits
        else
          @outfits = @episode.outfits
        end
      else
        @outfits = @show.characters.includes(:outfits).map { |character| character.outfits}.uniq.flatten
      end
    elsif params[:movie_id]
      @movie = Movie.find_by_slug(params[:movie_id])
      if params[:character_id]
        @character = @movie.characters.find_by_slug(params[:character_id])
        @outfits = @character.outfits
      elsif params[:scene_id]
        @scene = @movie.scenes.find(params[:scene_id])
        @outfits = @scene.outfits
      else
        @outfits = @movie.characters.includes(:outfits).map { |character| character.outfits}.uniq.flatten
      end
    else
      @outfits = Outfit.all
    end
    if params[:active]
      @outfits.keep_if{|o| (o.verified && o.approved)}
    end
    if params[:per_page] && params[:page]
      per_page = params[:per_page].to_i
      page = params[:page].to_i
      start_index = (page - 1) * per_page
      end_index = (page * per_page) - 1
      respond_with @outfits.order('id asc')[start_index..end_index]
    else
      respond_with @outfits.sort_by{|o| o.recent_airdate}.reverse
    end
  end

  # GET /shows/1
  # GET /shows/1.json
  api :GET, "/v1/outfits/:id", "Display the details of a given outfit"
  api :GET, "/v1/shows/:show_slug/outfits/:id", "Display the details of a given outfit"
  api :GET, "/v1/shows/:show_slug/characters/:character_slug/outfits/:id", "Display the details of a given outfit"
  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/outfits/:id", "Display the details of a given outfit"
  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id/outfits/:id", "Display the details of a given outfit"
  description "Returns an outfit that contains an array of products"
  def show
    respond_with @outfit
  end

  # # POST /shows
  # # POST /shows.json
  # api :POST, "/v1/shows/", "Create a show"
  # description "Used to create a show. Will return the JSON representation of the created show."
  # def create
  # end

  # # PATCH/PUT /shows/1
  # # PATCH/PUT /shows/1.json
  # api :PATCH, "/v1/shows/:slug", "Update an existing show."
  # description "Used to update an existing show. Will return a 204 response"
  # def update
  # end

  # # DELETE /shows/1
  # # DELETE /shows/1.json
  # api :DELETE, "/v1/shows/:slug", "Delete an existing show."
  # description "Used to delete an existing show. Will return a 204 response"
  # def destroy
  #   respond_with @show.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_outfit
      @outfit = Outfit.find_by_id(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def outfit_params
      params.require(:outfit).permit(:id)
    end
end