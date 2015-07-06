class CreateSceneImages < ActiveRecord::Migration
  def change
    create_table :scene_images do |t|
      t.references :scene, index: true
      t.attachment :avatar

      t.string :alt_text
      t.boolean :primary
      t.boolean :cover
      t.timestamps
    end
  end
end