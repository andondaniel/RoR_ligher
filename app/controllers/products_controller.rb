class ProductsController < ApplicationController
  # GET /products
  # GET /products.json
  def index
    # @products = Product.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
      format.js
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    if params[:show_id]   
      @show = Show.find_by(id: params[:show_id]) || Show.find_by(slug: params[:show_id])
    end
    
    @product = Product.find_by(id: params[:id])
    if (@product.outfits.any?) && (@product.outfits.first.episodes.any?)
      @episode = @product.outfits.first.episodes.first
      @episodenumber = @episode.episode_number
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
end