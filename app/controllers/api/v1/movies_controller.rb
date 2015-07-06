class API::V1::MoviesController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json
  before_action :set_movie, only: [:show, :update, :destroy]
  # before_action :default_serializer_options

  resource_description do
    short "Movies covered by Spylight"
    formats ['json']
    description "The slugs used to identify movies are simply id of the movie followed by a hyphen and then the name of the movie with any spaces replaced with hyphens."
  end

  def_param_group :episode_params do 
    param :episode, Hash, action_aware: true do
      param :name, String, desc: "Movie's name", required: true
    end
  end
  
  api :GET, "/v1/movies", "Lists all movies supported by Spylight"
  description "Returns an Array of all movies. Each movie in the array contains nested objects relevant to them. E.g., each movie will contain an array of scenes and an array of movie images."
  param :cache_update, Integer, desc: "takes an integer value and returns all episodes with an greater than that value. Used for finding all new episodes since last cache update. Note: If you enter a value for cache update all other params are ignored."
  param :active, [true, false], desc: "boolean marker that when set to true only returns active objects"
  def index
    if params[:cache_update]
      @movies = Movie.where("id > ?", params[:cache_update])
    else
      @movies = Movie.all
    end
    if params[:active]
      @movies.keep_if{|m| (m.verified && m.approved)}
    end
    respond_with @movies
  end

  api :GET, "/v1/movies/:slug", "Fetches details of a single movie"
  def show
    respond_with @movie
  end

  # api :POST, "/v1/shows/:show_slug/episodes", "Create a new episode"
  # description "Create an episode for a given show. Will return a JSON representation of the show for which you just created an episode" #This should really just return the episode, but that creates an error for some reason
  # param_group :episode_params
  # def create
  #   @show.episodes.build(episode_params)
  #   @show.save
  #   respond_with @show 
  # end

  # api :PATCH, "/v1/shows/:show_slug/episodes/:slug", "Update an existing episode"
  # description "Used to update an existing episode within a given show. Will return a 204 response."
  # param_group :episode_params
  # def update
  #   respond_with @episode.update_attributes(episode_params)
  # end

  # api :DELETE, "/v1/shows/:show_slug/episodes/:slug", "Delete an existing episode"
  # description "Used to delete an existing episode within a given show. Will return a 204 response."
  # def destroy
  #   respond_with @episode.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def movie_params
      params.require(:episode).permit(:name, :season, :episode_number)
    end
end
