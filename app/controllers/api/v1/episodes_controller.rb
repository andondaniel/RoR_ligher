class API::V1::EpisodesController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json
  before_action :set_episode, only: [:show, :update, :destroy]
  before_action :set_show, only: [:index, :create]
  # before_action :default_serializer_options

  resource_description do
    short "Episodes grouped by show"
    formats ['json']
    description "The slugs used to identify episodes are of the following format:
    The slug of the associated show, hyphen, the word season, value of the season variable, hyphen, the word episode,  value of the episode_number variable. e.g.,
    new-girl-season1-episode1"
  end

  def_param_group :episode_params do 
    param :episode, Hash, action_aware: true do
      param :name, String, desc: "Episode's name", required: true
      param :season, Fixnum, desc: "Season number", required: true
      param :episode_number, Fixnum, desc: "Which episode of a given season it is", required: true
      #param :airdate, DateTime, desc: "Original Airdate of the episode"
    end
  end
  
  api :GET, "/v1/shows/:show_slug/episodes", "Lists all episodes for a given show"
  description "Returns an Array of all episodes of the selected show. Each episode in the array contains nested objects relevant to them. E.g., each episode will contain an array of scenes and an array of episode links (links to video streams of the episode)."
  param :cache_update, Integer, desc: "takes an integer value and returns all episodes with an greater than that value. Used for finding all new episodes since last cache update. Note: If you enter a value for cache update all other params are ignored."
  param :active, [true, false], desc: "boolean marker that when set to true only returns active objects"
  def index
    if params[:cache_update]
      @episodes = Episode.where("id > ?", params[:cache_update])
    elsif @show
      @episodes = @show.episodes
    else
      @episodes = Episode.all
    end
    if params[:active]
      @episodes.keep_if{|e| (e.verified && e.approved)}
    end
    respond_with @episodes.where("airdate IS NOT NULL").order('airdate DESC')
  end

  api :GET, "/v1/shows/:show_slug/episodes/:slug", "Fetches details of a single episode"
  def show
    respond_with @episode
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
    def set_episode
      set_show
      @episode = @show.episodes.find_by_slug(params[:id])
    end

    def set_show
      @show = Show.find_by_slug(params[:show_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params.require(:episode).permit(:name, :season, :episode_number)
    end
end
