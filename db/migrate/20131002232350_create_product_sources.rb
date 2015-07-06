class CreateProductSources < ActiveRecord::Migration
  def change
    create_table :product_sources do |t|
      t.text :url
      t.money :price
      t.string :status
      t.references :store, index: true
      t.references :product, index: true

      t.timestamps
    end
  end
end
