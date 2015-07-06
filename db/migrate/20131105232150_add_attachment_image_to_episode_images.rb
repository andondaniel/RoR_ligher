class AddAttachmentImageToEpisodeImages < ActiveRecord::Migration
  def self.up
    change_table :episode_images do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :episode_images, :image
  end
end
