class RemoveProductsFromOutfits < ActiveRecord::Migration
  def change
    remove_column :outfits, :product_id
  end
end
