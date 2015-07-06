class AddPrimaryToEpisodeImages < ActiveRecord::Migration
  def change
    add_column :episode_images, :primary, :boolean
  end
end
