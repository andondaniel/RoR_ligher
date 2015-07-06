class AddFlagToProductSets < ActiveRecord::Migration
  def change
  	add_column :product_sets, :flag, :boolean, default: false
  end
end
