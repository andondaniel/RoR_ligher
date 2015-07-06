class AddIdToOutfitsProducts < ActiveRecord::Migration
  def change
    add_column :outfits_products, :id, :primary_key
  end
end
