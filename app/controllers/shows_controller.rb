class ShowsController < ApplicationController
  before_action :set_show, only: [:show]
  before_action :set_main_menu
  before_action :categories

  # GET /shows
  # GET /shows.json
  def index
    @shows = Show.all
  end

  # GET /shows/1
  # GET /shows/1.json
  def show
    @show = Show.find(params[:id])
    @products = @show.products.active.uniq
    @characters = @show.characters.active
    @outfits = @show.outfits.approved.uniq
  end

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
