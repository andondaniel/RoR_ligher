class HomeController < ApplicationController
  before_action :categories
  before_action :set_main_menu

  def index
    @outfits_featured = Outfit.includes(:show).where(featured: true).take(2)
    @characters_featured = Character.where(featured: true).take(2)
  end

  def about
  end

  def contact
  end

  def network_menu
    @network = Network.find_by(id: params[:network_id])
    @default = @network.shows.active.first.show_images.cover.first.avatar.url(:medium)
    respond_to do |format|  
      format.js
      format.html
    end
  end

  def mailchimp
    respond_to do |format|
      format.js
    end
  end

  def requestaccess
    respond_to do |format|
      format.js
    end
  end

  def character_menu
    @show = Show.find_by(id: params[:show_id])
    @characters = @show.characters.active
    respond_to do |format|
      format.js
      format.html
    end
  end

  private


end