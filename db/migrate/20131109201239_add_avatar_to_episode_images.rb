class AddAvatarToEpisodeImages < ActiveRecord::Migration
  def change
    add_attachment :episode_images, :avatar
  end
end