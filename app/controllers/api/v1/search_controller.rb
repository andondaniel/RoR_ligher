class API::V1::SearchController < ApplicationController
  protect_from_forgery with: :null_session
  respond_to :xml, :json

  resource_description do
    short "Spylight Full Text Search"
    description "Allows a user to perform a search across all indexed models. Results are ranked based on their relevance to the most salient features of Spylight objects and are grouped by model."
    formats ['json']
  end

  def_param_group :search_params do
    param :search, String, desc: "query that is going to be used in search", required: true
    param :quantity, Integer, desc: "maximum number of results to be returned for each category. A quantity of 0 will retun all results. default: 10"
    param :shows, [true, false], desc: "boolean that determines if show results will be included. default: true"
    param :characters, [true, false], desc: "boolean that determines if character results will be included. default: true"
    param :episodes, [true, false], desc: "boolean that determines if episode results will be included. default: true"
    param :categories, [true, false], desc: "boolean that determines if category results will be included. default: true"
    param :products, [true, false], desc: "boolean that determines if product results will be included. default: true"
 end

  api :GET, "/v1/search", "Search Spylight"
  description "Returns search results related to a given query. The results are organized by model type, and the output for each model is a simple json representation of the object (not the serialized version found in other resoruces). Results can be filtered/limited with params."
  param_group :search_params
  def index
    @query = params[:search]
    @search = Search.new(query: @query)

    respond_with @search, root: false
  end


end