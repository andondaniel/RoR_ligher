class RemoveProductImageFromOutfits < ActiveRecord::Migration
  def change
    remove_column :outfits, :product_image_id
  end
end
