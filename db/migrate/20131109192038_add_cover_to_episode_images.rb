class AddCoverToEpisodeImages < ActiveRecord::Migration
  def change
    add_column :episode_images, :cover, :boolean
  end
end
