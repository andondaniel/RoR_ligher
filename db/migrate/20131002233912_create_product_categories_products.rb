class CreateProductCategoriesProducts < ActiveRecord::Migration
  def change
    create_table :product_categories_products, id: false do |t|
      t.references :product_category, index: true
      t.references :product, index: true
    end
  end
end
