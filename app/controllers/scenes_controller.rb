class ScenesController < ApplicationController
  before_action :set_scene, only: [:show]

  # GET /scenes
  # GET /scenes.json
  def index
    @scenes = Scene.all
  end

  # GET /scenes/1
  # GET /scenes/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scene
      @scene = Scene.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scene_params
      params.require(:scene).permit(:start_time, :end_time)
    end
end
