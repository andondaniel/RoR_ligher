class AddDeletedAtToModels < ActiveRecord::Migration
  def change
     add_column :characters, :deleted_at, :datetime
     add_column :episodes, :deleted_at, :datetime
     add_column :outfits, :deleted_at, :datetime
     add_column :products, :deleted_at, :datetime
     add_column :scenes, :deleted_at, :datetime
     add_column :shows, :deleted_at, :datetime
  end
end
