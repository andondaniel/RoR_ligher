class AddFlagToOutfits < ActiveRecord::Migration
  def change
    add_column :outfits, :flag, :boolean
  end
end
