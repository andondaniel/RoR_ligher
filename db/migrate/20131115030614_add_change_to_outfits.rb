class AddChangeToOutfits < ActiveRecord::Migration
  def change
    add_column :outfits, :change, :string
  end
end
