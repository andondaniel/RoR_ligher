class AddProductSetIdToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :product_set, index: true
  end
end
