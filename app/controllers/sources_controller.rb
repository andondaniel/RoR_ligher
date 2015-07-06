class SourcesController < ApplicationController
	before_action :set_source, only: [:update]


	def update
    if @source.update(source_params)
      redirect_to admin_sources_path, notice: 'Source was successfully updated.'
    else
      redirect_to admin_sources_path, notice: 'Unable to update source'
    end
  end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_source
      @source = Source.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def source_params
      params.require(:source).permit(:new_price_value, :new_price_currency, :in_stock, :available, :link_checked, :sourceable_id, :sourceable_type)
    end
end
