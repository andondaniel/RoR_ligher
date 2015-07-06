class CreateOutfitsProducts < ActiveRecord::Migration
  def change
    create_table :outfits_products, id: false do |t|
      t.references :outfit, index: true
      t.references :product, index: true
    end
  end
end