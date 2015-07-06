class AddExactMatchToOutfitProducts < ActiveRecord::Migration
  def change
    add_column :outfits_products, :exact_match, :boolean
  end
end
