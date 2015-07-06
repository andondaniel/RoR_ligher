class CreatePropsScenes < ActiveRecord::Migration
  def change
    create_table :props_scenes do |t|
      t.references :prop, index: true
      t.references :scene, index: true
      t.boolean :exact_match

      t.timestamps
    end
  end
end
