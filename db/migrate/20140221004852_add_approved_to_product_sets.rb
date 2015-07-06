class AddApprovedToProductSets < ActiveRecord::Migration
  def change
  	add_column :product_sets, :approved, :boolean, default: false
  end
end
