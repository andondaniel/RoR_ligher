class AddMoreVerifications < ActiveRecord::Migration
  def change
    add_column :character_images, :verified, :boolean
    add_column :episode_images,   :verified, :boolean
    add_column :outfit_images,    :verified, :boolean
    add_column :product_images,   :verified, :boolean
    add_column :movie_images, :verified, :boolean
    add_column :scenes,   :verified, :boolean
    add_column :scene_images,    :verified, :boolean
    add_column :show_images,   :verified, :boolean
    add_column :durations,   :verified, :boolean
  end
end
