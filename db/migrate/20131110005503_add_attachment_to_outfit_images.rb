class AddAttachmentToOutfitImages < ActiveRecord::Migration
  def change
    add_attachment :outfit_images, :avatar
  end
end
