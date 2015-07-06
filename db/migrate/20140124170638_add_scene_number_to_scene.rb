class AddSceneNumberToScene < ActiveRecord::Migration
  def change
    add_column :scenes, :scene_number, :integer
  end
end
