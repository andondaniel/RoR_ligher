class AddDescriptionToOutfits < ActiveRecord::Migration
  def change
    add_column :outfits, :description, :text, default: "Outfit Description Unavailable"
  end
end
