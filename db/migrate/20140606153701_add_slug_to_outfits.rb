class AddSlugToOutfits < ActiveRecord::Migration
  def change
    add_column :outfits, :slug, :string
    add_index :outfits, :slug
  end
end
