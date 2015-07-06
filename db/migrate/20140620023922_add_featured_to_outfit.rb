class AddFeaturedToOutfit < ActiveRecord::Migration
  def up
    add_column :outfits, :featured, :boolean, default: false

    Outfit.update_all({featured: true}, {id: [294, 453]})
  end

  def down
    remove_column :outfits, :featured
  end
end
