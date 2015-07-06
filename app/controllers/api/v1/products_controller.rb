 class API::V1::ProductsController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json
  before_action :set_product, only: [:show, :update, :destroy]
  # before_action :default_serializer_options

  resource_description do
    short "Products seen on our supported shows."
    formats ['json']
    description "The slugs used to identify products are the id of the product followed by the downcased name of the product where all spaces have been replaced with hyphens"
  end

  def_param_group :product_params do
    param :product, Hash, action_aware: true do
      param :name, String, desc: "Humanized name of the product", required: true
      param :description, String, desc: "Textual description of the item"
      param :approved, [true, false], desc: "Boolean marker of whether or not the item has been approved by an admin" #This needs to be limited access. Only Admins should be able to change the approval status
    end
  end

  # def_param_group :product_attributes do
  #   param :include_product_attributes, Hash do
  #     param :id, [true, false], desc: "Boolean flag for displaying product id in JSON response. Default is true"
  #     param :name, [true, false], desc: "Boolean flag for displaying product name in JSON response. Default is true"
  #     param :description, [true, false], desc: "Boolean flag for displaying product description in JSON response. Default is false"
  #     param :approved, [true, false], desc: "Boolean flag for displaying product approval status in JSON response. Default is true"
  #     param :slug, [true, false], desc: "Boolean flag for displaying product slug in JSON response. Default is true"
  #     param :colors, [true, false], desc: "Boolean flag for displaying product colors hash in JSON response. Default is false"
  #     #The last two need to be changed to embedding behavior rather than simple display behavior
  #     param :product_images, [true, false], desc: "Boolean flag for displaying product images in JSON response. Default is false"
  #     param :product_sources, [true, false], desc: "Boolean flag for displaying product sources in JSON response. Default is true"
  #   end
  # end

  api :GET, "/v1/products", "List all products"
  api :GET, "/v1/shows/:show_slug/products", "Lists all products for a given show"
  api :GET, "/v1/shows/:show_slug/characters/:character_slug/products", "Lists all products for a given character"
  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/products", "Lists all products for a given episode"
  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id/products", "Lists all products for a given scene"
  description "Array of all relevant products. Individual nodes within the array map onto JSON representations of products"
  # param_group :product_attributes
  param :cache_update, Integer, desc: "takes an integer value and returns all products with an greater than that value. Used for finding all new products since last cache update. Note: If you enter a value for cache update all other params are ignored."
  param :active, [true, false], desc: "boolean marker that when set to true only returns active objects"
  def index
    if params[:cache_update]
      @products = Product.where("id > ?", params[:cache_update])
    elsif params[:show_id]
      @show = Show.find_by_slug(params[:show_id])
      if params[:character_id]
        @character = @show.characters.find_by_slug(params[:character_id])
        @products = @character.products
      elsif params[:episode_id]
        @episode = @show.episodes.find_by_slug(params[:episode_id])
        if params[:scene_id]
          @scene = @episode.scenes.find(params[:scene_id])
          @products = @scene.outfits.map { |outfit| outfit.products }.flatten.compact.uniq
        else
          @products = @episode.products
        end
      else
        @products = @show.characters.map { |character| character.products}.uniq.flatten
      end
    else
      @products = Product.all
    end
    if params[:active]
      @products.keep_if{|p| (p.verified && p.approved)}
    end
    respond_with @products
  end

  api :GET, "/v1/products/:product_slug", "Display the details of a given product"
  description "Details included are: id, name, description, approved (whether or not an admin as approved the item to go live), slug, a hash of colors the product is available in(keys correspond to color codes), an array of product_images, and an array of product_sources"
  api :GET, "/v1/shows/:show_slug/products/:product_slug", "Display the details of a given product"
  api :GET, "/v1/shows/:show_slug/characters/:character_slug/products/:product_slug", "Display the details of a given product"
  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/products/:product_slug", "Display the details of a given product"
  api :GET, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id/products/:product_slug", "Display the details of a given product"
  # param_group :product_attributes
  def show
    respond_with @product
  end


  #Needs Work. Specifically, needs to be able to incorporate params that aren't a part of the scoped URL.
  # api :POST, "/v1/products", "Create a new product"
  # api :POST, "/v1/shows/:show_slug/products", "Create a new product"
  # api :POST, "/v1/shows/:show_slug/characters/:character_slug/products", "Create a new product"
  # api :POST, "/v1/shows/:show_slug/episodes/:episode_slug/products", "Create a new product"
  # api :POST, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id/products", "Create a new product"
  # param_group :product_params
  # description "Used for creating a new product within the given scope."
  # def create
  #   product = Product.new(product_params)
  #   if params[:character_id]
  #     product.character = Character.find_by_slug(params[:character_id])
  #   end
  #   if params[:episode_id]
  #     product.episodes << Episode.find_by_slug(params[:episode_id])
  #   end
  #   respond_with product.save
  # end

  # #Similar to the create method, this needs to accommodate building associations through param entry.
  # api :PATCH, "/v1/products/:product_slug", "Update an existing product"
  # api :PATCH, "/v1/shows/:show_slug/products/:product_slug", "Update an existing product"
  # api :PATCH, "/v1/shows/:show_slug/characters/:character_slug/products/:product_slug", "Update an existing product"
  # api :PATCH, "/v1/shows/:show_slug/episodes/:episode_slug/products/:product_slug", "Update an existing product"
  # api :PATCH, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id/products/:product_slug", "Update an existing product"
  # param_group :product_params
  # description "Used for updating an existing product. Will return a 204 response"
  # def update
  #   respond_with @product.update_attributes(product_params)
  # end

  # api :DELETE, "/v1/products/:product_slug", "Destroy a given product"
  # api :DELETE, "/v1/shows/:show_slug/products/:product_slug", "Destroy a given product"
  # api :DELETE, "/v1/shows/:show_slug/characters/:character_slug/products/:product_slug", "Destroy a given product"
  # api :DELETE, "/v1/shows/:show_slug/episodes/:episode_slug/products/:product_slug", "Destroy a given product"
  # api :DELETE, "/v1/shows/:show_slug/episodes/:episode_slug/scenes/:scene_id/products/:product_slug", "Destroy a given product"
  # description "Used to delete an existing product. Will return a 204 response"
  # def destroy
  #   respond_with @product.destroy
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find_by_slug(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :approved)
    end
end
