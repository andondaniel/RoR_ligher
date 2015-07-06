class AddContainsExactMatchToOutfits < ActiveRecord::Migration
  def change
    add_column :outfits, :contains_exact_match, :boolean
  end
end
