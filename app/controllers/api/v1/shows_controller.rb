class API::V1::ShowsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json
  before_action :set_show, only: [:show, :update, :destroy]
  # before_action :default_serializer_options

  resource_description do
    short "Supported Television Shows"
    description "The slugs used to identify shows are simply the downcased name of the show where all spaces have been replaced with hyphens"
    formats ['json']
  end

  def_param_group :show_params do
    param :show, Hash, action_aware: true do
      param :name, String, desc: "Humanized name of the show", required: true
   end
 end

  # GET /shows
  # GET /shows.json
  api :GET, "/v1/shows", "Lists all shows"
  description "Returns an Array of all supported shows. Each show in the array contains an id, name, and slug, as well as the slugs of objects relevant to that show. E.g., each show has an array of character slugs and episode slugs."
  param :cache_update, Integer, desc: "takes an integer value and returns all episodes with an greater than that value. Used for finding all new episodes since last cache update. Note: If you enter a value for cache update all other params are ignored."
  param :active, [true, false], desc: "boolean marker that when set to true only returns active objects"
  def index
    if params[:cache_update]
      @shows = Show.where("id > ?", params[:cache_update])
    else
      @shows = Show.all
    end
    if params[:active]
      @shows.keep_if{|s| (s.verified && s.approved)}
    end
    respond_with @shows
  end

  # GET /shows/1
  # GET /shows/1.json
  api :GET, "/v1/shows/:slug", "Fetches details of a single show"
  description "Returns a JSON node with name 'show' that contains the show's name, id, and slug as well as an array of character slugs and episode slugs within that show."
  def show
    respond_with @show
  end

  # # POST /shows
  # # POST /shows.json
  # api :POST, "/v1/shows/", "Create a show"
  # description "Used to create a show. Will return the JSON representation of the created show."
  # param_group :show_params
  # def create
  #   respond_with Show.create(show_params)
  # end

  # # PATCH/PUT /shows/1
  # # PATCH/PUT /shows/1.json
  # api :PATCH, "/v1/shows/:slug", "Update an existing show."
  # description "Used to update an existing show. Will return a 204 response"
  # param_group :show_params
  # def update
  #   respond_with @show.update_attributes(show_params)
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
    def set_show
      @show = Show.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_params
      params.require(:show).permit(:name)
    end
end