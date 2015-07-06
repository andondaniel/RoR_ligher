class AddCharacterIdToOutfits < ActiveRecord::Migration
  def change
    add_reference :outfits, :character, index: true
  end
end
