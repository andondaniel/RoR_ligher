class AddAvatarToPropImage < ActiveRecord::Migration
  def change
  	add_attachment :prop_images, :avatar
  end
end
