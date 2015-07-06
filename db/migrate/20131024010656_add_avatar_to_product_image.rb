class AddAvatarToProductImage < ActiveRecord::Migration
  def change
    add_attachment :product_images, :avatar
  end
end
