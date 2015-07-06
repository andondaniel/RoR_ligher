class RemoveScenesFromOutfits < ActiveRecord::Migration
  def change
    remove_column :outfits, :scene_id
  end
end
