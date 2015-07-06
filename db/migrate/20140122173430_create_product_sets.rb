class CreateProductSets < ActiveRecord::Migration
  def change
    create_table :product_sets do |t|

      t.timestamps
    end
  end
end
