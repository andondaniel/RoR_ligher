class API::V1::ProductCategoriesController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json
  before_action :set_product_category, only: [:show]

  resource_description do
    short "Product Categories"
    formats ['json']
  end

  # GET /product_categories
  # GET /product_categories.json
  api :GET, "/v1/product_categories", "Lists all product_categories"
  description "Product categories index."
  def index
    @product_categories = ProductCategory.all
    respond_with @product_categories
  end

  # GET /shows/1
  # GET /shows/1.json
  api :GET, "/v1/product_categories/:id", "Fetches details of a single product category"
  description "Returns a JSON node with the id, name and gender of a product category"
  def show
    respond_with @product_category
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
    def set_product_category
      @product_category = ProductCategory.find(params[:id])
    end

end