class RenamePrimaryOnCharacterImages < ActiveRecord::Migration
  def change
  	rename_column :character_images, :primary, :thumbnail
  end
end
