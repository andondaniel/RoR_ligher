class AddInStockToProductSources < ActiveRecord::Migration
  def change
  	add_column :product_sources, :in_stock, :boolean
  end
end
