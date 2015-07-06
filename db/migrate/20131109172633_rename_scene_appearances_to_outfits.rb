class RenameSceneAppearancesToOutfits < ActiveRecord::Migration
  def change
  	rename_table :scene_appearances, :outfits
  end
end
