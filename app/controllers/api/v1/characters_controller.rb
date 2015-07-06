class API::V1::CharactersController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json
  before_action :set_character, only: [:show, :update, :destroy]
  before_action :set_show, only: [:index, :create]
  before_action :set_movie, only: [:index]
  # before_action :default_serializer_options

  resource_description do
    short "Characters arranged by the show in which they appear"
    formats ['json']
    description "The slugs used to identify characters are the id of the character followed by and hyphen and then the downcased name of the character where all spaces have been replaced with hyphens"
  end

  def_param_group :character_params do 
    param :character, Hash, action_aware: true do
      param :name, String, desc: "Character's name"
    end
  end


  api :GET, "/v1/shows/:movie_slug/characters", "Lists all characters for a given movie"
  api :GET, "/v1/shows/:show_slug/characters", "Lists all characters for a given show"
  description "Returns an Array of all characters appearing in the selected show. Each character in the array contains a nested array of character images and an array of outfit_ids (corresponding to the outfits they have worn)."
  param :cache_update, Integer, desc: "takes an integer value and returns all characters with an greater than that value. Used for finding all new characters since last cache update. Note: If you enter a value for cache update all other params are ignored."
  param :top_nine, [true,false], desc: "boolean marker that when set to true will limit results to the most important nine characters for a given show or movie. No guest stars will be listed even if there are less than nine non-guest stars. Defaults to false"
  param :active, [true, false], desc: "boolean marker that when set to true only returns active objects. Defaults to false"
  def index
    if params[:cache_update]
      @characters = Character.where("id > ?", params[:cache_update])
    elsif @show
      if params[:top_nine]
        @characters = @show.characters.order(:importance).limit(9).delete_if{|c| c.guest == true} rescue nil
      else
        @characters = @show.characters
      end
    elsif @movie
      if params[:top_nine]
         @characters = @movie.characters.order(:importance).limit(9) rescue nil
      else
        @characters = @movie.characters
      end
    else
      @characters = Character.all
    end
    if params[:active]
      @characters.keep_if{|c| (c.verified && c.approved)}
    end
    respond_with @characters
  end


  api :GET, "/v1/shows/:movie_slug/characters/:slug", "Fetches details of a single character"
  api :GET, "/v1/shows/:show_slug/characters/:slug", "Fetches details of a single character"
  description "Returns a JSON node with name 'character' that contains the characters's name, id, and slug as well as an array of outfit_ids and images associated with that character."
  def show
    respond_with @character
  end

  # api :POST, "/v1/shows/:show_slug/characters", "Creates a character with a set of optional attributes"
  # description "Used to create a character within a given show. Will return the JSON representation of the created character."
  # param_group :character_params
  # def create
  #   @show.characters.build(character_params)
  #   @show.save
  #   respond_with @show.characters.last #hacked way of accessing that character, should be refactored
  # end

  # api :PATCH, "/v1/shows/:show_slug/characters/:slug", "Update an existing character"
  # description "Used to update an existing character within a given show. Will return a 204 response."
  # param_group :character_params
  # def update
  #   respond_with @character.update_attributes(character_params)
  # end

  # api :DELETE, "/v1/shows/:show_slug/characters/:slug", "Delete an existing character"
  # description "Used to delete an existing character. Will return a 204 response."
  # def destroy
  #   respond_with @character.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      set_show
      set_movie
      if @show
        @character = @show.characters.find_by_slug(params[:id])
      else
        @character = @movie.characters.find_by_slug(params[:id])
      end
    end

    def set_show
      @show = Show.find_by_slug(params[:show_id])
    end

    def set_movie
      @movie = Movie.find_by_slug(params[:movie_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def character_params
      params.require(:character).permit(:name)
    end
end
