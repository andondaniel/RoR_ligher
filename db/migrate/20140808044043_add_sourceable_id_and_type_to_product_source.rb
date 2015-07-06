class AddSourceableIdAndTypeToProductSource < ActiveRecord::Migration
  def change
  	add_column :product_sources, :sourceable_id, :integer, index: true
  	add_column :product_sources, :sourceable_type, :string
  end
end
