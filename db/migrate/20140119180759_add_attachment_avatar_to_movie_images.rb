class AddAttachmentAvatarToMovieImages < ActiveRecord::Migration
  def self.up
    change_table :movie_images do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :movie_images, :avatar
  end
end
