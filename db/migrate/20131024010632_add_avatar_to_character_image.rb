class AddAvatarToCharacterImage < ActiveRecord::Migration
  def change
    add_attachment :character_images, :avatar
  end
end
