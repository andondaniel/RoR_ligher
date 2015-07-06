class CreateSceneAppearances < ActiveRecord::Migration
  def change
    create_table :scene_appearances do |t|
      t.integer :start_time
      t.integer :end_time
      t.references :product, index: true
      t.references :scene, index: true

      t.timestamps
    end
  end
end
