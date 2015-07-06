class CreateColorsProducts < ActiveRecord::Migration
  def change
    create_table :colors_products, id: false do |t|
      t.references :color, index: true
      t.references :product, index: true
    end
  end
end
