class CreateOutfitsScenes < ActiveRecord::Migration
  def change
    create_table :outfits_scenes, id: false do |t|
      t.references :outfit, index: true
      t.references :scene, index: true
    end
  end
end
