class CreateEpisodeImages < ActiveRecord::Migration
  def change
    create_table :episode_images do |t|
      t.references :episode, index: true
      t.string :image_type

      t.timestamps
    end
  end
end
