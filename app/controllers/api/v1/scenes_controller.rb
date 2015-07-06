class API::V1::ScenesController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json
  before_action :set_scene, only: [:show, :update, :destroy]
  before_action :set_episode, only: [:index, :create]
  before_action :default_serializer_options


  resource_description do
    short "Scenes grouped by episode"
    formats ['json']
  end

  def_param_group :scene_params do
    param :scene, Hash, action_aware: true do
      param :start_time, Fixnum, desc: "Start time of the scene relative to the beginning of the episode. Measured in seconds."
      param :end_time, Fixnum, desc: "End time of the scene relative to the beginning of the episode. Measured in seconds."
    end
  end

  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/scenes", "Lists all scenes for a given episode"
  api :GET, "/v1/movies/:movie_slug/scenes", "Lists all scenes for a given movie"
  description "Displays all the scenes for a given episode/movie. Scenes will contain an array of products that appear within them."
  def index
    if @episode
      @scenes = @episode.scenes
    elsif @movie
      @scenes = @movie.scenes
    else
      @scenes = []
    end 
    respond_with @scenes
  end

  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id", "Fetches a particular scene"
  description "Displays the start and end time of a given scene as well as the products that appear during that time span. "
  def show
    respond_with @scene
  end

  # api :POST, "/v1/shows/:show_slug/episodes/:episode_slug/scenes", "Creates a new scene within a given episode"
  # param_group :scene_params
  # description "Used to create a new scene within a given episode. Returns the JSON representation of the altered episode" #Should probably return the created scene, rather than the full episode
  # def create
  #   @episode.scenes.build(scene_params)
  #   @episode.save
  #   respond_with @episode
  # end

  # api :PATCH, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id", "Updates the attributes of a particular scene"
  # param_group :scene_params
  # description "Used to update an existing scene. Will return a 204 response"
  # def update
  #   respond_with @scene.update_attributes(scene_params)
  # end

  # api :DELETE, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id", "Deletes a particular scene"
  # description "Used to delete an existing scene. Will return a 204 response"
  # def destroy
  #   respond_with @scene.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scene
      set_episode
      set_movie
      if @episode
        @scene = @episode.scenes.find(params[:id])
      elsif @movie
        @scene = @movie.scenes.find(params[:id])
      else
        return
      end
    end

    def set_show
      if params[:show_id]
        @show = Show.find_by_slug(params[:show_id])
      end
    end

    def set_movie
      if params[:movie_id]
        @movie = Movie.find_by_slug(params[:movie_id])
      end
    end

    def set_episode
      set_show
      if @show
        @episode = @show.episodes.find_by_slug(params[:episode_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scene_params
      params.require(:scene).permit(:name)
    end
end
