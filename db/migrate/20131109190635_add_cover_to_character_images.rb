class AddCoverToCharacterImages < ActiveRecord::Migration
  def change
    add_column :character_images, :cover, :boolean
  end
end
