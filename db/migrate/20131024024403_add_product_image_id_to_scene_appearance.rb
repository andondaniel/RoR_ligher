class AddProductImageIdToSceneAppearance < ActiveRecord::Migration
  def change
    add_column :scene_appearances, :product_image_id, :integer, index: true
  end
end