class API::V1::StarsController < API::V1::ApplicationController
  protect_from_forgery with: :null_session
  respond_to :json
  before_action :authenticate
  
  #skips csrf check
  skip_before_filter :verify_authenticity_token

  resource_description do
    short "Spylight Stars"
    formats ['json']
    description "Stores information about what resources users have favorited (starred)"
  end

  def_param_group :star_params do
    param :star, Hash do
      param :starable_type, ["Product", "Outfit", "Show", "Character", "Movie"], desc: "Type of Resource to be favorited", required: true
      param :starable_id, Integer, desc: "ID of favorited resource", required: true
   end
 end


  api :POST, "/v1/stars/", "Creates a star with a set of required attributes"
  description "Used to create a star association. Will return the JSON representation of the created star. Requires auth token in header."
  param_group :star_params
  def create
    if current_user
      @star = Star.new(star_params)
      @star.user = @current_user
      if @star.save
        render json: "Star association properly saved."
      else
        render json: "A problem has occured while attempting to save the star association."
      end
    else
      render json: "Invalid auth token"
    end
  end

  api :DELETE, "/v1/stars/:id", "Delete an existing star association"
  description "Used to delete an existing star association. Will return a 204 response."
  def destroy
    @star = Star.find(params[:id])
    respond_with @star.destroy
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def star_params
     params.require(:star).permit(:starable_id, :starable_type)
    end

end