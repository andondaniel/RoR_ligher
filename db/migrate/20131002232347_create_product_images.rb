class CreateProductImages < ActiveRecord::Migration
  def change
    create_table :product_images do |t|
      t.string :url
      t.string :alt_text
      t.references :product, index: true

      t.timestamps
    end
  end
end
